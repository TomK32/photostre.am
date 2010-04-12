require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PhotosController do
  before :each do
    @website = Factory(:website_with_albums_and_photos)
    @website.albums << Factory(:album, {:state => 'deleted', :website => @website})
    @website.albums << Factory(:album, {:state => 'draft', :website => @website})
    
    @photos = @website.photos
    @request.host = @website.domains.first
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
    it "shows album by permalink or id"
  end

  it "does not show draft albums" do
    draft_album = @website.albums.find_all_by_state("draft").first
    get :show, :id => draft_album.permalink
    assert_response 404
  end
  it "does not show deleted albums" do
    deleted_album = @website.albums.find_all_by_state('deleted').first
    get :show, :id => deleted_album.permalink
    assert_response 404
  end

  it "does not show an album belonging to a different website" do
    other_website = Factory(:website_with_albums_and_photos)
    other_album = other_website.albums.first
    @website.album_ids.should_not include(other_album.id)

    get :show, :id => other_album.permalink
    assigns[:current_object].should be(nil)
    assert_response 404
  end

end
