
class Rvc
  class Repo
    attr_reader :path
    
    def initialize(path)
      @path = File.expand_path(path)
      raise "Directory doesn't exist." unless File.exist?(@path)
      raise "Repo needs a directory, not a file." unless File.directory?(@path)
    end
    
    def initialized?
      rvc_dir_exists?
    end
    
    def init
      unless rvc_dir_exists?
        FileUtils.mkdir(rvc_dir)
      end
    end
    
    def commit(username, message)
      tree = write_tree(path)
      commit = Commit.new(head_sha, username, message, tree.to_sha)
      write_object(commit)
      update_head(commit.to_sha)
    end
    
    def log
      @log ||= Rvc::Log.new(self)
    end
    
    def checkout(commit)
      clear_working_dir
      checkout_tree(commit.tree_sha, path)
    end
    
    def checkout_tree(tree_sha, dir)
      tree = object(tree_sha)
      tree.contents.each do |tree_row|
        type, sha, name = *tree_row
        case type
        when "blob"
          checkout_blob(sha, dir + "/" + name)
        when "tree"
          subdir = dir + "/" + name
          FileUtils.mkdir_p(subdir)
          checkout_tree(sha, subdir)
        end
      end
    end
    
    def checkout_blob(blob_sha, path)
      blob = object(blob_sha)
      File.open(path, "w") {|f| f.print blob.contents }
    end
    
    def blob_at_path(tree, path)
      bits = path.split("/")
      if bits.length == 1
        tree.contents.each {|type, sha, name| return object(sha) if name == bits[0]}
        nil
      else
        tree.contents.each do |type, sha, name| 
          if name == bits[0]
            if type == "tree"
              tree = object(sha)
              return blob_at_path(tree, bits[1..-1].join("/"))
            else
              raise "looking for file inside of a file"
            end
          end
        end
        nil
      end
    end

    def write_tree(path)
      contents = []
      Dir[path + "/*"].each do |subpath|
        name = File.basename(subpath)
        if File.directory?(subpath)
          tree = write_tree(subpath)
          contents << ["tree", tree.to_sha, name]
        else
          blob = write_blob(subpath)
          contents << ["blob", blob.to_sha, name]
        end
      end
      tree = Tree.new(contents)
      write_object(tree)
      tree
    end
    
    def write_blob(path)
      contents = File.read(path)
      blob = Blob.new(contents)
      write_object(blob)
      blob
    end
    
    def head
      sha = head_sha
      return nil unless sha
      read_object(sha)
    end
    
    def head_sha
      return nil unless File.exist?(head_path)
      File.read(head_path)
    end
    
    CONTENT_TAGS = {
      "c:" => Commit,
      "b:" => Blob,
      "t:" => Tree
    }
    
    CONTENT_TAG_LENGTH = 2
    
    def object(sha_or_object)
      case sha_or_object
      when String
        read_object(sha_or_object)
      when Commit, Blob, Tree
        sha_or_object
      when nil
        nil
      end
    end
    
    def read_object(sha)
      return nil unless sha
      filename = object_filename(sha)
      return nil unless File.exist?(filename)
      content = File.read(filename)
      content = Zlib::Inflate.inflate(content) if CLI::ZLIB_ON
      content_type = content[0..(CONTENT_TAG_LENGTH - 1)]
      klass = CONTENT_TAGS[content_type]
      klass.from_data(content[CONTENT_TAG_LENGTH..-1])
    end

    def clear_working_dir
      Dir[path + "/*"].each do |subpath|
        unless File.basename(subpath) == ".rvc"
          FileUtils.rm_rf(subpath)
        end
      end
    end
    
    private
    
    def write_object(object)
      ensure_objects_dir
      sha = object.to_sha
      filename = object_filename(sha)
      FileUtils.mkdir_p(File.dirname(filename))
      content_type = CONTENT_TAGS.invert[object.class]
      File.open(filename, "w") do |fout|
        content = content_type + object.to_data
        content = Zlib::Deflate.deflate(content) if CLI::ZLIB_ON
        fout.print content
      end
    end
    
    def update_head(sha)
      File.open(head_path, "w") {|fout| fout.print sha }
    end
    
    def head_path
      rvc_dir + "/HEAD"
    end
    
    def rvc_dir_exists?
      File.exist?(rvc_dir)
    end
    
    def rvc_dir
      @path + "/.rvc"
    end
    
    def objects_dir
      rvc_dir + "/objects"
    end
    
    def ensure_objects_dir
      File.exist?(objects_dir) || FileUtils.mkdir(objects_dir)
    end
    
    def object_filename(sha)
      objects_dir + "/" + sha[0..1] + "/" + sha[2..-1]
    end
  end
end











