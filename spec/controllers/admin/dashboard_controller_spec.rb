require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::DashboardController do

  before do
    @user ||= Factory(:user)
    @user.websites << Factory(:website)
    @user.sources << @source = Factory(:source)
    @user.photos << (0..7).collect{ Factory(:photo, :user_id => @user.id, :source_id => @source.id)}
    @user.reload
    @system_website = Website.system.first || Factory(:website_system)
  end
  before :each do
    request.host = @system_website.domains.first
  end
  describe "as not logged in user" do
    it "should not let me in" do
      get :index
      response.should_not be_success
    end
  end
  describe "as logged in user" do
    before :each do
      request.session[:user_id] = @user.id
      get :index
    end
    it "should be success" do
      response.should be_success
    end
    it "should assign recent photos" do
      assigns[:photos].should == @user.photos.recent.all(:limit => 8)
    end
    it "should assign websites" do
      assigns[:websites].should == @user.websites
    end
    it "should assign sources" do
      assigns[:sources].should == @user.sources
    end
  end
end
