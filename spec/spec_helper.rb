
require 'lib/rvc'

def test_repo1_dir
  File.dirname(__FILE__) + "/fixtures/test-repo1"
end

def test_repo1
  Rvc::Repo.new(test_repo1_dir)
end

def restore_test_repo1
  FileUtils.rm_rf(test_repo1_dir)
  FileUtils.cd(File.expand_path(test_repo1_dir + "/../")) do
    `tar xzf test-repo1.tar.gz`
  end
end

RSpec.configure do |config|
  config.before(:each) do
    restore_test_repo1
  end
  
  config.after(:each) do
    restore_test_repo1
  end
end
