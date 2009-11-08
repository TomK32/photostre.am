require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PhotosController do

  def setup
    request.host = Factory(:website_system).domain
    @user = Factory(:user)
    request.session[:user_id] = @user.id
  end
  it "should only work for logged in users" do
    get :index
    controller.should have_before_filter(:authenticated)
    response.should be_success
  end
  describe "filters" do
    it "should find photos by tags"
    it "should find photos by search term on description and title"
    it "should paginate photos"
  end
  it "should only show the current_user's photos"
  it "should add a photo to several websites"
  it "should add a photo to several alubms"
  it "should add several photos to websites"
end
