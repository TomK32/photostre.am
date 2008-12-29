require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Website do
  fixtures :websites
  before(:each) do
    @website = Website.first
  end
  it "@website should be valid" do
    @website.should be_valid
    @website.domain.should == 'photos.tomk32.de'
  end
  describe "associations" do
    it "should have and belong to many users" do
      @website.should have_and_belong_to_many(:users)
    end
  end
  describe "scopes" do
    it "should have :active scope" do
      @website.update_attribute(:active, true)
      active_websites = Website.all(:conditions => {:active => true})
      Website.active.should == active_websites
      @website.update_attribute(:active, false)
      Website.active.should == active_websites.reject!{|w| w.id == @website.id }
    end
  end
end
