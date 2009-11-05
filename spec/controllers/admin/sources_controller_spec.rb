require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::SourcesController do
  def setup
    request.host = Factory(:website_system).domain
    @user = Factory(:user)
    request.session[:user_id] = @user.id
  end
  it "should only work for logged in users" do
    get :index
    controller.should have_before_filter(:authenticated).with({:skip => {:only => [:create, :authenticate_flickr_account]}})
    response.should be_success
  end
end
