require 'lib/rvc_object'
require 'lib/storage_adapter'
require 'lib/commit'
require 'lib/tree'
require 'lib/blob'

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
    
    def all
      
    end
    
    def head_commit
      sha = File.read(@dir + '/HEAD')
      @storage.find(sha)
    end
    
    def log
      show_commit(head_commit)  
    end
    
    def checkout
      head_commit.tree.checkout_into("workspace")
    end
    
    def show_commit(commit)
      puts "Message: #{commit.message}"
      puts "Author: #{commit.author}"
      show_commit(commit.parent) unless not commit.parent.is_a? Commit
    end
    
    def render_tree(tree)
      
    end
  end
end