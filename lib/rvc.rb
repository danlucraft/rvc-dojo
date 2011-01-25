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
      @storage = StorageAdapter.new(self)
    end
    
    def path
      @dir
    end
    
    def find(object_hash)
      @storage.find(object_hash)
    end
    
    def head_commit
      sha = File.read(@dir + '/HEAD')
      @storage.find(sha)
    end
    
    def log
      [head_commit, head_commit.parent].each do |commit|
        puts "Message: #{commit.message}"
        puts "Author: #{commit.author}"
      end
    end
  end
end