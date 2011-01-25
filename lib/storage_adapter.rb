class StorageAdapter
  def initialize(repo)
    @repo = repo
    @path = repo.path
  end
  
  def find(object_hash)
    path = @path + "/objects/#{object_hash[0..1]}/#{object_hash[2..-1]}"
    text_data = Zlib::Inflate.inflate(File.read(path))
    parts = text_data.split(':')
    type = parts.shift
    rest = parts * ':'
    case type
    when 'c' then RVC::Commit.new(@repo, rest)
    end
  end
end