require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PhotosController do
  def setup
    @website = Factory(:website)
    @website.photos = (0..20).collect { Factory(:photo) }
    @photos = @website.photos
  end
  before :each do
    request.host = @website.domains.first
  end

  describe "GET to :index" do
    before :each do
      get :index
    end
    it "assigns current_website" do
      assigns[:current_website].should == @website
    end
    it "assigns current_objects" do
      assigns[:photos].should == @photos.reverse[0...5]
    end
    it "should not show deleted photos"
  end

  describe "GET to :show" do
    before :each do
      @photo = @photos.first || Factory(:photo)
    end
    it "should accept a photo id" do
      get :show, :id => @photo.id
      assigns[:current_object].should == @photo
    end
    it "should accept a permalink" do
      get :show, :id => @photo.permalink
      assigns[:current_object].should == @photo
    end
    it "should render a 404 for non-existing photo" do
      get :show, :id => 'no-such-photo'
      assert_response 404
    end
    describe "photos with password" do
      it "should request a password for restricted photos"
      it "should a 403 for unauthorized access"
      it "should show photo with correct password"
    end
  end
  
  describe "photos belonging to an album" do
    before :each do
      @album = Album.first || Factory(:album)
      @photo = @photos.first
      @photo.albums << @album
      @album.reload
      @photo.reload
    end
    describe "GET to :index with an album" do
      before :each do
        get :index, :album_id => @album.permalink
      end
      it "should assign album" do
        assigns[:current_album].should ==(@album)
        assigns[:current_objects].should ==(@album.photos[0..10])
      end
    end
    describe "GET to :show with an album" do
      before :each do
        get :show, :album_id => @album.permalink, :id => @photo.permalink
      end
      it "should assign album" do
        assigns[:current_album].should ==(@album)
        assigns[:current_object].should ==(@photo)
      end
    end
  end
end
