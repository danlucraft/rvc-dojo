
require 'spec_helper'

describe "Rvc::Log" do
  def log
    Rvc::Log.new(Rvc::Repo.new(test_repo1_dir))
  end
  
  it "should be valid with a Repo" do
    Rvc::Log.new(Rvc::Repo.new(test_repo1_dir))
  end
  
  it "should be invalid without a Repo" do
    lambda { Rvc::Log.new(1) }.should raise_error(RuntimeError, "Log needs a Repo")
  end
  
  it "should return an empty log for an uninitialized repo" do
    log.to_s.should == "No commits."
  end
end
