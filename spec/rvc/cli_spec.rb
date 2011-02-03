
require 'spec_helper'

describe "Rvc::CLI" do
  it "should accept arguments" do
    cli = Rvc::CLI.new(["init", 1, 2])
    cli.args.should == [1, 2]
    cli.command.should == "init"
  end
  
  it "should set the current working directory" do
    FileUtils.cd(test_repo1_dir) do
      cli = Rvc::CLI.new(["init"])
      cli.cwd.should == test_repo1_dir
    end
  end
  
  it "should raise an error for an unknown command" do
    lambda {
      cli = Rvc::CLI.new([:xxx, 1, 2])
    }.should raise_error(RuntimeError, "Unknown command xxx.")
  end
  
  describe "init command" do
    before do
      FileUtils.cd(test_repo1_dir) do
        @cli = Rvc::CLI.new(["log"])
      end
    end

    it "should call init on the Repo" do
      @cli.repo.should_receive(:init)
      @cli.init
    end
  end
  
  describe "log command" do
    before do
      FileUtils.cd(test_repo1_dir) do
        @cli = Rvc::CLI.new(["log"])
      end
    end
    
    it "should fail if this is not a repo" do
      lambda {
        @cli.log
      }.should raise_error(RuntimeError, "Not an RVC repository.")
    end
    
    it "should forward onto the log class if it is a repo" do
      @cli.repo.init
      @cli.repo.log.stub!(:to_s).and_return("My Log")
      @cli.log.to_s.should == "My Log"
    end
  end
  
  describe "commit command" do
    before do
      FileUtils.cd(test_repo1_dir) do
        @cli = Rvc::CLI.new(["commit", "dan", "First commit"])
      end
    end
    
    it "should fail if this is not a repo" do
      lambda {
        @cli.commit
      }.should raise_error(RuntimeError, "Not an RVC repository.")
    end
    
    it "should extract arguments and pass on to the repo commit" do
      @cli.repo.init
      @cli.repo.should_receive(:commit).with("dan", "First commit")
      @cli.commit
    end
    
    it "should print usage if the wrong number of args are given" do
      FileUtils.cd(test_repo1_dir) do
        @cli = Rvc::CLI.new(["commit", "dan"])
      end
      @cli.repo.init
      @cli.commit.should == "usage: rvc commit USERNAME MESSAGE"
    end
  end
end




