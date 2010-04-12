require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::ThemesController do
  def setup
    request.host = Factory(:website_system).domains.first
    @user = Factory(:user)
    request.session[:user_id] = @user.id
  end

  it "should only work for logged in users" do
    get :index
    controller.should have_before_filter(:authenticated)
    response.should be_success
  end
  
  describe ":index" do
    it "should show themes available" 
    it "should show themes created by user"
  end
  describe ":new" do
    it "should render form"
    it "should render list of common theme files"
  end
  describe ":edit" do
    it "should allow managing custom fields"
    it "should allow setting number of photos"
  end
end
