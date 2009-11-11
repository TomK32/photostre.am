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
  describe ":create" do
    it "should create a user when creating a new flickr source"
=begin do

      post :create, {:source => {:username => 'TomK%i' % User.count, :source_type => 'Source::FlickrAccount'}}
#      response.should be_redirect
      new_user = User.find_by_login('TomK32')
      new_source = Source::FlickrAccount.find_by_username('TomK32')
#      assert new_user
      assert new_source
      new_user.sources.should include(new_source)
      
=end
    
    it "should log in the user for existing sources" do
      Factory(:user, :login => 'TomK32', :email => 'tomk32@gmx.de')
      post :index, {:source => {:username => 'TomK32'}}
      response.should be_success
    end
  end
  describe ":index" do
    it "should only show sources belong to current_user" do
      source = Factory(:source, :user => @user)
      other_user = Factory(:user)
      other_source = Factory(:source, :user_id => other_user.id)
      get :index
      assigns[:current_objects].should_not include(other_source)
      assigns[:current_objects].should include(source)
    end
  end
end
