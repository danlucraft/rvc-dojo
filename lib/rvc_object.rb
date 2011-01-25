require 'zlib'

class RVCObject
  attr_reader :object_hash
  
  def initialize(object_hash)
    @object_hash = object_hash
  end

  def contents
    @contents ||= Zlib::Inflate.inflate(read_file)
  end

  def contents_type
    contents.split(':').first
  end
  
  def contents_other_stuff
    contents.split(':').last.split('/')
  end
  
  private

end