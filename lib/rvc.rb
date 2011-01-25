require 'lib/rvc_object'
require 'lib/storage_adapter'
require 'lib/commit'

class RVC
  def self.log(dir)
    Repo.new(dir).log
  end
  
  class Repo
    def initialize(dir)
      @dir = File.expand_path(dir)
      @storage = StorageAdapter.new(@dir)
    end
    
    def head_commit
      sha = File.read(@dir + '/HEAD')
      @storage.find(sha)
    end
    
    def log
      p head_commit
      return
      $bbqhead = RVCObject.new(File.read(@head))
      puts "Object type is: #{$bbqhead.contents_type}"
      puts "Other stuff is: #{$bbqhead.contents_other_stuff.inspect}"
    end
  end
end