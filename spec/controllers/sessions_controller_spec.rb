require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  integrate_views
  before :each do
    Factory(:website, :domain => 'photos.tomk32.de')
  end

  it "should have authenticate form send request to OpenID provider" do
    get :new
    response.should have_tag('input[type=?]#openid_identifier', 'text')
    post :create, :openid_identifier => 'http://tomk32.myopenid.com'
    response.should be_redirect
  end
  
  it "should accept response from OpenID provider"
#    get :create, {"openid.sreg.nickname"=>"TomK32", "openid.claimed_id"=>"http://tomk32.myopenid.com/", "openid.mode"=>"id_res", "openid.ns.sreg"=>"http://openid.net/extensions/sreg/1.1", "openid.return_to"=>"http://localhost/sessions?_method=post&open_id_complete=1", "openid.sig"=>"F7YcKbQleMeOHowbUdesFzv4lsM=", "openid.sreg.fullname"=>"Thomas R. Koll", "openid.ns"=>"http://specs.openid.net/auth/2.0", "openid.op_endpoint"=>"http://www.myopenid.com/server", "action"=>"create", "_method"=>"post", "openid.response_nonce"=>"2008-11-10T13:34:01ZzkC3K2", "controller"=>"sessions", "openid.sreg.email"=>"tomk32@gmx.de", "openid.identity"=>"http://tomk32.myopenid.com/", "open_id_complete"=>"1", "openid.assoc_handle"=>"{HMAC-SHA1}{49146608}{qlUheg==}", "openid.signed"=>"assoc_handle,claimed_id,identity,mode,ns,ns.sreg,op_endpoint,response_nonce,return_to,signed,sreg.email,sreg.fullname,sreg.nickname"}
  
  it "should create user account for new identity with sreg"
  
  it "should show user form for identty without sreg"
  # {"openid.mode"=>"id_res", "openid.return_to"=>"http://localhost/sessions?_method=post&open_id_complete=1", "openid.claimed_id"=>"http://www.flickr.com/photos/tomk32", "openid.sig"=>"YWOfcY8ARyYznYhtJbdpRAQC0+o=", "openid.ns"=>"http://specs.openid.net/auth/2.0", "openid.op_endpoint"=>"https://open.login.yahooapis.com/openid/op/auth", "action"=>"create", "_method"=>"post", "openid.response_nonce"=>"2008-11-10T13:30:50ZTqePYRfDkK8dJuJihgwY1cXH1WRj6oMP1Q--", "controller"=>"sessions", "openid.pape.nist_auth_level"=>"0", "openid.identity"=>"http://www.flickr.com/photos/tomk32", "open_id_complete"=>"1", "openid.pape.auth_policies"=>"none", "openid.assoc_handle"=>"KkT9mdnh.r.OkOuU6dSwAvYwx2RpR727zzte5aoHd8rWilOXtiQvoTxmI64dPzdQWWaqUKdizkmLx75WLphPB_ME8CFiSV591TGld90Rv0WrH6v2zq0SdYqYaPKoxxk-", "openid.signed"=>"assoc_handle,claimed_id,identity,mode,ns,ns.pape,op_endpoint,pape.auth_policies,pape.nist_auth_level,response_nonce,return_to,signed", "openid.realm"=>"http://localhost/", "openid.ns.pape"=>"http://specs.openid.net/extensions/pape/1.0"}

end
