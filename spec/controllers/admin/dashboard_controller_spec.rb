require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::DashboardController do

  def setup
    request.host == Factory(:website, :state => 'system').domain
    # there's only the index action, nothing else
  end
  describe "as not logged in user" do
    it "should not let me in" do
      get :index
      response.should_not be_success
    end
  end
  describe "as logged in user" do
    before :each do
      @user = Factory(:user)
      @user.websites << Factory(:website_with_photos)
      @user.reload
      request.session[:user_id] = @user.id
      get :index
    end
    it "should be success" do
      response.should be_success
    end
    it "should assign recent photos" do
      assigns[:photos].should == @user.photos.recent(:limit => 8)
    end
    it "should assign websites" do
      assigns[:website].should == @user.websites
    end
    it "should assign sources" do
      assigns[:sources].should == @user.sources
    end
  end
end
