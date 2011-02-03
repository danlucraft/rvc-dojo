
require 'spec_helper'

describe "Rvc::Repo" do
  it "should be invalid without a valid directory" do
    lambda {
      Rvc::Repo.new("/asdfasdfasdf/asdfjioag/asdf")
    }.should raise_error(RuntimeError, "Directory doesn't exist.")
  end
  
  it "should be invalid if given a file" do
    lambda {
      Rvc::Repo.new(test_repo1_dir + "/foo.rb")
    }.should raise_error(RuntimeError, "Repo needs a directory, not a file.")
  end
  
  it "should be valid with a valid directory" do
    lambda {
      Rvc::Repo.new(test_repo1_dir)
    }.should_not raise_error
  end
  
  it "should expand and let you access the directory path" do
    test_repo1.path.should == File.expand_path(test_repo1_dir)
  end
  
  context "uninitialized repo" do
    it "should report that a repo is uninitialized" do
      test_repo1.should_not be_initialized
    end
    
    it "should let you init the repo" do
      repo = test_repo1
      repo.init
      repo.should be_initialized
    end
    
    it "should be initialized across Repo instantiations" do
      test_repo1.init
      test_repo1.should be_initialized
    end
  end
  
  context "just initialized repo" do
    before do
      test_repo1.init
    end
    
    it "should have no HEAD" do
      test_repo1.head.should be_nil
    end
    
    describe "after the first commit" do
      before do
        test_repo1.commit("dan", "Initial commit.")
      end
      
      it "the head should exist" do
        test_repo1.head.should_not be_nil
      end
      
      it "should put the commit info in the log" do
        test_repo1.log.to_s.should include("Initial commit.")
      end
    end
    
    describe "after the 2nd commit" do
      before do
        test_repo1.commit("dan", "Initial commit.")
        test_repo1.commit("dan", "2nd commit")
      end
      
      it "the head should exist" do
        test_repo1.head.should_not be_nil
      end
      
      it "should put the commit info in the log" do
        test_repo1.log.to_s.should include("2nd commit")
        test_repo1.log.to_s.should include("Initial commit.")
      end
    end
  end
  
  context "repo with commits with added file" do
    before do
      test_repo1.init
      test_repo1.commit("dan", "Initial commit.")
      FileUtils.touch(test_repo1_dir + "/newfile.txt")
      File.open(test_repo1_dir + "/dir1/baz.rb", "w") {|f| f.print "STOLE YOUR CODE"}
      test_repo1.commit("dan", "2nd commit")
    end
    
    describe "checking out an earlier release" do
      before do
        repo = test_repo1
        orig_commit = repo.read_object(repo.head.parent_sha)
        repo.checkout(orig_commit)
      end
      
      it "should remove new files from the working tree" do
        File.exist?(test_repo1_dir + "/newfile.txt").should be_false
      end
      
      it "should return modified files to their previous state" do
        File.read(test_repo1_dir + "/dir1/baz.rb").should == "baz baz baz\n"
      end
      
      describe "then checking out head again" do
        before do
          repo = test_repo1
          repo.checkout(repo.head)
        end
        
        it "should add new files back in" do
          File.exist?(test_repo1_dir + "/newfile.txt").should be_true
        end
        
        it "should put modified content back" do
          File.read(test_repo1_dir + "/dir1/baz.rb").should == "STOLE YOUR CODE"
        end
      end
    end
  end
end






















