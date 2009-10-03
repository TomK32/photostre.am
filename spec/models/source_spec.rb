require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require RAILS_ROOT + '/app/models/source/flickr_account'
describe Source do
  before(:each) do
    @source = Factory(:source)
  end
  it "@source should be valid" do
    @source.should be_valid
  end
  describe "associations" do
    it "should have and belong to many users" do
      @source.should belong_to(:user)
    end
    it "should have many photos" do
      @source.should have_many(:photos)
    end
  end
  describe "scopes" do
    it "should have :active scope" do
      @source.update_attribute(:active, true)
      active_sources = Source.all(:conditions => {:active => true})
      Source.active.should == active_sources
      @source.update_attribute(:active, false)
      Source.active.should == active_sources.reject!{|w| w.id == @source.id }
    end
  end
end
