require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @user = Factory(:user)
  end
  it "@user should be valid" do
    @user.should be_valid
  end
  describe "associations" do
    it { should have_many_related(:photos) }
    it { should have_many(:websites) }
    it { should embed_one(:subscription) }
    it { should embed_many(:old_subscriptions) }
    it { should embed_many(:features) }
    it { should embed_many(:sources) }
  end
  describe "fields" do
    
  end
  describe "validations" do
    
  end
  
  describe "features and subscriptions" do
    it "should have a method "
  end
end
