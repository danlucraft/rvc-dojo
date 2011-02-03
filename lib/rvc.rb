
$:.push(File.dirname(__FILE__))

require 'fileutils'
require 'digest/sha1'
require 'zlib'

require 'rubygems'
require 'differ'

require 'rvc/blob'
require 'rvc/commit'
require 'rvc/tree'

require 'rvc/cli'
require 'rvc/diff'
require 'rvc/log'
require 'rvc/repo'

class Rvc
  class << self
    attr_accessor :cli
  end
  
  def self.go(args)
    @cli = Rvc::CLI.new(args)
    @cli.execute
  end
end
