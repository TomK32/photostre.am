require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Website do
  before(:each) do
    @website = Factory(:website)
  end
  it "@website should be valid" do
    @website.should be_valid
  end
  describe "associations" do
    it "should have and belong to many users" do
      @website.should have_and_belong_to_many(:users)
    end
    it "should have and belong to many sources" do
      @website.should have_many(:sources)
    end
  end
  describe "scopes" do
    it "should have :active scope" do
      @website.update_attribute(:state, 'active')
      active_websites = Website.all(:conditions => {:state => 'active'})
      Website.active.should == active_websites
      @website.update_attribute(:state, 'draft')
      Website.active.should == active_websites.reject!{|w| w.id == @website.id }
    end
  end
end
