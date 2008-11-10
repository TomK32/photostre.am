require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  integrate_views

  it "should have authenticate form send request to OpenID provider" do
    get :new
    response.should have_tag('input[type=?]#openid_identifier', 'text')
    post :create, :openid_identifier => 'http://tomk32.myopenid.com'
    response.should be_redirect
  end
  
  it "should accept response from OpenID provider"
  
  it "should create user account for new identity with sreg"
  
  it "should show user form for identty without sreg"

end
