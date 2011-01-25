class RVC
  class Commit
    def initialize(repo, serialized)
      @repo  = repo
      @tuple = serialized.split('/')
    end 
    
    def author
      @tuple[2]
    end
    
    def message
      @tuple[3]
    end
    
    def parent
      @repo.find(@tuple[0]) rescue nil
    end
    
    def tree
      @repo.find(@tuple[1])
    end
  end
end
