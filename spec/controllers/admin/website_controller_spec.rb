require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::WebsitesController do

  before do
    @user = Factory(:user)
    @website = Website.system.first.domains.first || Factory(:website_system).domains.first
  end
  before :each do

#    request.host = @website.domains.first
#    request.session[:user_id] = @user.id
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
      post :create, {:website => {:title => 'Test', :domains => 'test.com'}}
      assigns[:resource].should be_valid
      assigns[:resource].user_ids.should include(@user.id)
    end
  end
  describe ":edit" do
    it "should allow setting any public theme"
    it "should allow setting any theme by the user"
    it "should not allow setting theme created by other users"
  end
  describe ":create with subscription" do
    it "should create a new website" do
      post :create, {:website => {:title => 'Test', :domain => 'tomk32.de'}}
      response.should be_redirect
      assigns[:resource].should be_valid
      assigns[:resource].domains.should ==(['tomk32.de'])
      assert @user.websites.where(:domains => 'tomk32.de').first
    end
    it "should use create a new subdomain under system domain" do
      Factory(:website, :domain => 'funny.com', :state => 'system')
      assert_nil @user.websites.where(:domains => 'test.funny.com').first
      post :create, {:subdomain => 'test', :domain => 'funny.com', :website => {:title => 'Test'}}
      response.should be_redirect
      assigns[:resource].should be_valid
      assigns[:resource].domains.should ==(['test.funny.com'])
      assert @user.websites.where(:domains => 'test.funny.com').first
    end
    it "should create a new subdomain under a user domain" do
      @user.websites << Factory(:website, :domains => ['user.com'])
      assert_nil @user.websites.where(:domains => 'test.user.com').first
      post :create, {:subdomain => 'test', :domain => 'user.com', :website => {:title => 'Test'}}
      response.should be_redirect
      assigns[:resource].should be_valid
      assigns[:resource].domains.should ==(['test.user.com'])
      assert @user.websites.where(:domains => 'test.user.com').first
    end
    it "should not create a new subdomain under a non-existing domain" do
      assert_nil @user.websites.where(:domains => 'test.bad.com').first
      post :create, {:subdomain => 'test', :domain => 'bad.com', :website => {:title => 'Test'}}
      response.should_not be_success
      assigns[:resource].should_not be_valid
    end
    it "should not create a new subdomain under someone elses domain" do
      other_website = Factory(:website, :domains => ['theirs.com'], :user_ids => [Factory(:user).id])
      assert_nil @user.websites.where(:domains => 'theirs.com').first
      post :create, {:subdomain => 'test', :domain => 'theirs.com', :website => {:title => 'Test'}}
      response.should_not be_success
      assigns[:resource].should_not be_valid
    end
    it "should prefer domain field as input" do
      post :create, {:subdomain => 'test', :domain => 'funny.com', :website => {:title => 'Test', :domain => 'notfunny.com'}}
      response.should be_redirect
      assigns[:resource].should be_valid
      assigns[:resource].domains.should ==(['notfunny.com'])
    end
    it "should return error if subdomain is empty" do
      post :create, {:domain => 'funny.com', :website => {:title => 'Test'}}
      response.should_not be_success
      assigns[:resource].should_not be_valid
    end
    it "should return error if domain is empty" do
      post :create, {:subdomain => 'test', :website => {:title => 'Test'}}
      response.should_not be_success
      assigns[:resource].should_not be_valid
    end
  end
  describe ":destroy" do
    it "should set state to deleted"
  end
end
