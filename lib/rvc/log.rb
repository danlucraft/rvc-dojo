
class Rvc
  class Log
    def initialize(repo)
      @repo = repo
      unless repo.class <= Repo
        raise "Log needs a Repo"
      end
    end
    
    def to_s
      if current = @repo.head
        log_lines = []
        while current
          log_lines << current.to_sha + "  " + current.created_at.to_s + "  " + current.username.rjust(10, " ") + "  " + current.message
          current = @repo.read_object(current.parent_sha)
        end
        log_lines.join("\n")
      else
        "No commits."
      end
    end
  end
end
