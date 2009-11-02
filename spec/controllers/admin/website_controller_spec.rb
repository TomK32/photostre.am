require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::WebsitesController do

  def setup
    request.host == Factory(:website, :state => 'system').domain
    @user = Factory(:user)
    request.session[:user_id] = @user.id
    # there's only the index action, nothing else
  end
  it "should only work for logged in users" do
    get :index
    controller.should have_before_filter(:authenticated)
  end
  describe ":new without sufficient subscription" do
    it "should redirect to subscriptions"
  end
  describe ":edit" do
    it "should allow setting any public theme"
    it "should allow setting any theme by the user"
    it "should not allow setting theme created by other users"
  end
  describe ":create with subscription" do
    it "should create a new website"
  end
  describe ":destroy" do
    it "should set state to deleted"
  end
end
