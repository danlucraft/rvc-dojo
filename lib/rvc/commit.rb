
class Rvc
  class Commit
    def self.from_data(data)
      parent_sha, tree_sha, username, message, created_at = *data.split("/")
      parent_sha = nil if parent_sha == ""
      created_at = Time.at(created_at.to_i)
      Commit.new(parent_sha, username, message, tree_sha, created_at)
    end
    
    attr_reader :parent_sha, :username, :message, :tree_sha, :created_at
    
    def initialize(parent_sha, username, message, tree_sha, created_at = Time.now)
      @parent_sha   = parent_sha
      @username     = username
      @message      = message
      @created_at   = created_at
      @tree_sha     = tree_sha
    end
    
    def to_sha
      Digest::SHA1.hexdigest(to_data)
    end
    
    def to_data
      [parent_sha, tree_sha, username, message, created_at.to_i].join("/")
    end
  end
end
