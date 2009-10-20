require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Identity do
  before(:each) do
    @identity = Factory(:identity)
  end
  it "@identity should be valid" do
    @identity.should be_valid
  end
end
