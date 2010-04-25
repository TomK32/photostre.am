require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @user = Factory(:user)
  end
  it "@user should be valid" do
    @user.should be_valid
  end
  describe "associations" do
    it "should have many related :photos"
    it "should have many :websites"
    it "should embed one :subscription"
    it "should embed many :old_subscriptions"
    it "should embed many :features"
  end
  
  describe "features and subscriptions" do
    it "should have a method "
  end
end
