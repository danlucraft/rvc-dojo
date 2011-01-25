class RVC
  class Tree
    def initialize(repo, serialized)
      @repo  = repo
      @entries = {}
      @serialized = serialized
      p @entries.keys
    end
    
    def checkout_into(path)
      @serialized.split("\n").each do |line|
        obj_type, sha, filename = line.split(" ")
        case obj_type
        when "tree":
          `mkdir #{path}/#{filename}`
          @repo.find(sha).checkout_into("#{path}/#{filename}")
        when "blob":
          @repo.find(sha).write_to("#{path}/#{filename}")
        end
      end
    end
  end
end