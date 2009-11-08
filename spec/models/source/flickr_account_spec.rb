require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require RAILS_ROOT + '/app/models/source/flickr_account'
describe Source::FlickrAccount do
  before(:each) do
    @flickr_account = Factory(:source_flickr_account)
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
  
  describe "flickr api communication" do
    before :each do
      @tomk32 = Factory(:source_flickr_account, :username => 'TomK32' )
    end
    it "should set the :nsid" do
      @tomk32.set_nsid.should ==('99884191@N00')
    end
    it "should return a flickr object"
    it "should have a flickr object with a token"
    it "should reutrn a person object"
    it "should reutrn an authetication url" do
      @flickr_account.authentication_url.should_not be_blank
    end
  end
  
  describe "urls" do
    before :each do
      @tomk32 = Factory(:source_flickr_account, :username => 'TomK32' )
    end
    it "should have an url for photostream" do
      @tomk32.photostream_url.should == 'http://flickr.com/photos/TomK32'
    end
    it "should have an url for profile" do
      @tomk32.profile_url.should == 'http://flickr.com/people/TomK32'
    end
  end
  it "should be authenticated? if both, token and authenticated_at, are set" do
    @flickr_account.update_attributes({:token => false, :authenticated_at => Time.now})
    @flickr_account.should_not be_authenticated
    @flickr_account.update_attributes({:token => 'some-token'})
    @flickr_account.should be_authenticated
  end
  describe "worker" do
    it "should not created for deleted sources"
    it "should not created for unauthenticated sources"
    it "should be created"
  end
end
