require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PhotosController do
  before :each do
    @website = Factory(:website)
    @albums = (0..5).collect { Factory(:album) }
    @website.albums << Factory(:album, {:state => 'deleted'})
    @website.albums << Factory(:album, {:state => 'draft'})
    @website.photos = (0..20).collect { Factory(:photo) }
    @photos = @website.photos
  end

  describe "GET to :index" do
    before :each do
      get :index
    end
    it "assigns current_website" do
      assigns[:current_website].should == @website
    end
    it "assigns current_objects" do
      assigns[:photos].should == @photos[0..9]
    end
    it "assigns only published photos" do
      
    end
    it "has pagination"
    it "allows passing a per_page to current_objects"
    it "shows only albums of the current website"
  end
  
  describe "GET to :show" do
    before :each do
      @album = Album.first || Factory(:album)
      get :show, :id => @album.permalink
    end
    it "won't show an album belonging to a different website"
    it "shows only published albums"
    it "shows album by permalink or id"
  end

end
