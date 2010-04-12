require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PhotosController do

  before do
    @user = Factory(:user)
    @website = Factory(:website)
    @photos = (0..20).collect { Factory(:photo) }
    @user.websites << @website
  end
  before :each do
    request.host = Factory(:website_system).domains.first
    request.session[:user_id] = @user.id
    request.session[:user_id] = @user.id
  end
  it "should only work for logged in users" do
    controller.should have_before_filter(:authenticated)
  end
  describe "index" do
    describe "filters" do
      it "by tags"
      it "by search term on description and title"
      it "by website_id" do
        @website.photos << @photos[4..9]
        get :index, {:website_id => @website.id}
        assigns[:current_objects].collect(&:id).sort.should ==(@photos[4..9].collect(&:id).sort)
        assigns[:website].should == @website
      end
      it "by album_id" do
        album = Factory(:album, :website_id => @website.id)
        album.photos << @photos[2..9]
        get :index, {:album_id => album.id}
        assigns[:album].should == album
        assigns[:current_objects].collect(&:id).sort.should ==(@photos[2..9].collect(&:id).sort)
      end
      it "should not filter with bad album_id"
      it "should not filter with bad website_id"
    end
    it "should paginate photos"
    it "should only show the current_user's photos"
    it "should add a photo to several websites"
    it "should add a photo to several alubms"
    it "should add several photos to websites"
  end
end
