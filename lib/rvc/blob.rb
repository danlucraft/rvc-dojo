
class Rvc
  class Blob
    def self.from_data(contents)
      new(contents)
    end
    
    def self.from_file(path)
      new(File.read(path))
    end
    
    attr_reader :contents
    
    def initialize(contents)
      @contents = contents
    end
    
    def to_sha
      Digest::SHA1.hexdigest(contents)
    end
    
    def to_data
      contents
    end
  end
end
