require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::AlbumsController do

  before do
    @user = Factory(:user)
    @website = Factory(:website, :user_ids => [@user.id])
    @controller = Admin::AlbumsController.new
  end
  it "should only work for logged in users" do
    get :index, :website_id => @website.id
    request.session[:user_id] = @user.id
    request.host = Factory(:website_system).domains.first
    controller.should have_before_filter(:authenticated)
    response.should be_success
  end
end
