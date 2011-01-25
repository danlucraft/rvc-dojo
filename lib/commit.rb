class RVC
  class Commit
    def initialize(serialized)
      @tuple = serialized.split('/')
    end    
  end
end
