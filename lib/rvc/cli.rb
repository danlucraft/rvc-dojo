
class Rvc
  class CLI
    attr_reader :args, :cwd, :repo, :command
    
    COMMANDS = ["init", "log", "commit", "checkout", "show"]
    
    ZLIB_ON = true
    
    def initialize(args)
      @args = args
      @cwd = Dir.pwd
      @command = args.shift
      validate_command
      @repo = Rvc::Repo.new(@cwd)
    end
    
    def execute
      output = send(@command)
      puts output if output
    end
    
    def fail_unless_repo
      unless @repo.initialized?
        raise "Not an RVC repository."
      end
    end
    
    def init
      repo.init
      nil
    end
    
    def log
      fail_unless_repo
      repo.log
    end
    
    def commit
      fail_unless_repo
      unless args.length == 2
        return "usage: rvc commit USERNAME MESSAGE"
      end
      repo.commit(args[0], args[1])
    end
    
    def checkout
      fail_unless_repo
      unless args.length == 1
        return "usage: rvc checkout COMMIT"
      end
      
      commit = commit_from_id(args[0])
      @repo.checkout(commit)
      "Checked out \"#{commit.message}\" by #{commit.username}"
    end
    
    def commit_from_id(commit_id)
      if commit_id.length == 40
        commit_sha = commit_id
        @repo.object(commit_sha)
      elsif commit_id =~ /^HEAD(\^*)$/
        ups = $1.length
        commit = @repo.head
        ups.times do 
          commit = @repo.object(commit.parent_sha)
          unless commit
            raise "unknown commit #{commit_id}"
          end
        end
        commit
      end
    end
    
    def show
      fail_unless_repo
      unless args.length == 1 and args[0].split(":").length == 2
        return "usage: rvc show COMMIT:PATH"
      end
      commit_id, path = *args[0].split(":")
      commit = commit_from_id(commit_id)
      tree = @repo.object(commit.tree_sha)
      blob = @repo.blob_at_path(tree, path)
      blob ? blob.contents : "Can't find blob #{path}."
    end
    
    private
    
    def validate_command
      unless COMMANDS.include?(@command)
        raise "Unknown command #{@command}."
      end
    end
  end
end
