require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Photo do
  before(:each) do
    @photo = Factory.build(:photo)
  end

  it "should be valid" do
    @photo.should be_valid
  end
end
