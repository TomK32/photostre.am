require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::WebsitesController do

  def setup
    request.host = Factory(:website_system).domain
    @user = Factory(:user)
    request.session[:user_id] = @user.id
    # there's only the index action, nothing else
  end
  it "should only work for logged in users" do
    get :index
    controller.should have_before_filter(:authenticated)
  end
  describe ":index" do
    it "should be success" do
      get :index
      response.should be_success
    end
  end
  describe ":new without sufficient subscription" do
    it "should redirect to subscriptions"
  end
  describe ":create" do
    it "should belong to current_user" do
      post :create, {:website => {:site_title => 'Test', :domain => 'test.com'}}
      assigns[:current_object].should be_valid
      assigns[:current_object].user_ids.should include(@user.id)
    end
  end
  describe ":edit" do
    it "should allow setting any public theme"
    it "should allow setting any theme by the user"
    it "should not allow setting theme created by other users"
  end
  describe ":create with subscription" do
    it "should create a new website" do
      post :create, {:website => {:site_title => 'Test', :domain => 'tomk32.de'}}
      response.should be_redirect
      assigns[:current_object].should be_valid
      assigns[:current_object].domain.should ==('tomk32.de')
      assert @user.websites.find_by_domain('tomk32.de')
    end
    it "should use create a new subdomain under system domain" do
      Factory(:website, :domain => 'funny.com', :state => 'system')
      assert_nil @user.websites.find_by_domain('test.funny.com')
      post :create, {:subdomain => 'test', :domain => 'funny.com', :website => {:site_title => 'Test'}}
      response.should be_redirect
      assigns[:current_object].should be_valid
      assigns[:current_object].domain.should ==('test.funny.com')
      assert @user.websites.find_by_domain('test.funny.com')
    end
    it "should create a new subdomain under a user domain" do
      @user.websites << Factory(:website, :domain => 'user.com')
      assert_nil @user.websites.find_by_domain('test.user.com')
      post :create, {:subdomain => 'test', :domain => 'user.com', :website => {:site_title => 'Test'}}
      response.should be_redirect
      assigns[:current_object].should be_valid
      assigns[:current_object].domain.should ==('test.user.com')
      assert @user.websites.find_by_domain('test.user.com')
    end
    it "should not create a new subdomain under a non-existing domain" do
      assert_nil @user.websites.find_by_domain('test.bad.com')
      post :create, {:subdomain => 'test', :domain => 'bad.com', :website => {:site_title => 'Test'}}
      response.should_not be_success
      assigns[:current_object].should_not be_valid
    end
    it "should not create a new subdomain under someone elses domain" do
      other_website = Factory(:website, :domain => 'theirs.com', :users => [Factory(:user)])
      assert_nil @user.websites.find_by_domain('theirs.com')
      post :create, {:subdomain => 'test', :domain => 'theirs.com', :website => {:site_title => 'Test'}}
      response.should_not be_success
      assigns[:current_object].should_not be_valid
    end
    it "should prefer domain field as input" do
      post :create, {:subdomain => 'test', :domain => 'funny.com', :website => {:site_title => 'Test', :domain => 'notfunny.com'}}
      response.should be_redirect
      assigns[:current_object].should be_valid
      assigns[:current_object].domain.should ==('notfunny.com')
    end
    it "should return error if subdomain is empty" do
      post :create, {:domain => 'funny.com', :website => {:site_title => 'Test'}}
      response.should_not be_success
      assigns[:current_object].should_not be_valid
    end
    it "should return error if domain is empty" do
      post :create, {:subdomain => 'test', :website => {:site_title => 'Test'}}
      response.should_not be_success
      assigns[:current_object].should_not be_valid
    end
  end
  describe ":destroy" do
    it "should set state to deleted"
  end
end
