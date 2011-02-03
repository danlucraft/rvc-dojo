
require 'spec_helper'

describe "Rvc::Tree" do
  it "should initialize with a list of type, sha, name tuples" do
    contents = [["tree", "123", "lib"], ["blob", "4589", "README"]]
    tree = Rvc::Tree.new(contents)
    tree.contents.should == contents
  end
  
  it "should preserve contents through roundtrip" do
    contents = [["tree", "123", "lib"], ["blob", "4589", "README"]]
    tree = Rvc::Tree.from_data(Rvc::Tree.new(contents).to_data)
    tree.contents.should == contents
  end
end
