require 'tempfile'

class Rvc
  class Diff
    def diff(str1, str2)
      %x{diff #{file_for(str1)} #{file_for(str2)}}
    end
    
    def patch(orig, patch)
      orig_file = file_for(orig)
      patch_file = file_for(patch)
      %x{patch #{orig_file} #{patch_file}}
      File.read(orig_file)
    end
      
    private
    
    def file_for(text)
      exp = Tempfile.new("bk", "/tmp").open
      exp.write(text)
      exp.close
      exp.path
    end
  end
end
