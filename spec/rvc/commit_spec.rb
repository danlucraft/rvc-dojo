
require 'spec_helper'

describe "Rvc::Commit" do
  it "should initialize with a parent, username, message, tree sha and timestamp" do
    t = Time.now
    commit = Rvc::Commit.new("123", "dan", "asdf", "tree1", t)
    commit.parent_sha.should   == "123"
    commit.username.should == "dan"
    commit.message.should  == "asdf"
    commit.tree_sha.should == "tree1"
    commit.created_at.should == t
  end
  
  describe "from_data" do
    it "all data should survive roundtrip" do
      t = Time.now - 1000
      c = Rvc::Commit.from_data(Rvc::Commit.new(nil, "dan", "asdf", "tree1", t).to_data)
      c.parent_sha.should be_nil
      c.username.should == "dan"
      c.message.should == "asdf"
      c.tree_sha.should == "tree1"
      c.created_at.to_s.should == t.to_s
    end
  end
end
