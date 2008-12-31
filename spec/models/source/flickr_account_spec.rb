require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require RAILS_ROOT + '/app/models/source/flickr_account'
describe Source::FlickrAccount do
  fixtures :websites, :sources
  before(:each) do
    @flickr_account = Source::FlickrAccount.first
  end
  it "should be valid" do
    @flickr_account.should be_valid
  end

  describe "methods for type of source" do
    it "should be a subclass of Source" do
      @flickr_account.should be_kind_of(Source)
    end
    it "should have source_type" do
      @flickr_account.source_type.should == 'Source::FlickrAccount'
    end
    it "should have source_title" do
      @flickr_account.source_title.should == 'Flickr.com'
    end
  end
end
