
require 'spec_helper'

describe "Rvc::Blob" do
  it "should initialize with contents" do
    contents = "FAFASD"
    blob = Rvc::Blob.new(contents)
    blob.contents.should == contents
  end
  
  it "should preserve contents through roundtrip" do
    contents = "FAFASD"
    blob = Rvc::Blob.from_data(Rvc::Blob.new(contents).to_data)
    blob.contents.should == contents
  end
end
