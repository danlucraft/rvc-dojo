
class Rvc
  class Tree
    def self.from_data(data)
      lines = data.split("\n")
      contents = lines.map {|l| l.split(" ")}
      new(contents)
    end
    
    attr_reader :contents
    
    def initialize(contents)
      @contents = contents
    end
    
    def to_sha
      Digest::SHA1.hexdigest(to_data)
    end
    
    def to_data
      @contents.map {|r| r.join(" ")}.join("\n")
    end
    
  end
end
