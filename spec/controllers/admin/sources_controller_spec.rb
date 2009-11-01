require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::SourcesController do

  def setup
    request.host == Factory(:website, :state => 'system').domain
    @user = Factory(:user)
    request.session[:user_id] = @user.id
  end
  it "should only work for logged in users" do
    get :index
    controller.should have_before_filter(:authenticated)
    response.should be_success
  end
end
