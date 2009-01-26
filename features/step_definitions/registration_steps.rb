
Given /I am on the new session page/ do
  visit "/sessions/new"
end

Then /^I should be redirected to "(.*)"$/ do |url|
  if @response.redirected_to
    assert @response.redirected_to.match(url)
  else
    assert_redirected_to url
  end
end

Then /^I should see template "(.*)"$/ do |template|
  assert_template template
end

Then /^the request should be a "(.*)"$/ do |status|
  assert_response status.to_sym
end

Given /^that I have a complete OpenID as user "(.*)"$/ do |username|
  OpenIdAuthentication::Association.create!(
    :handle => '{HMAC-SHA1}{497cd9fc}{zzWlVQ==}',
    :server_url => 'http://www.myopenid.com/server',
    :lifetime => 1209600, :issued => 1232922430, :assoc_type => 'HMAC-SHA1',
    :secret => 'C;l#####.dX?L')
  visit '/sessions', :post, {"openid.sreg.nickname" => username,
    "openid.claimed_id" => "http://tomk32.myopenid.com/",
    "openid.mode" => "id_res",
    "openid.ns.sreg" => "http://openid.net/extensions/sreg/1.1",
    "openid.return_to" => "http://www.example.com/sessions?_method=post&open_id_complete=1",
    "openid.sig" => "abcdefghijklmnopqrstuvwxyz",
    "openid.sreg.fullname" => "Thomas R. Koll",
    "openid.ns" => "http://specs.openid.net/auth/2.0",
    "openid.op_endpoint" => "http://www.myopenid.com/server",
    "action" => "create",
    "_method" => "post",
    "openid.response_nonce" => "2009-01-26T18:23:20ZAP1WoW",
    "controller" => "sessions",
    "openid.sreg.email" => "tomk32@gmx.de",
    "openid.identity" => "http://tomk32.myopenid.com/",
    "open_id_complete" => "1",
    "openid.assoc_handle" => "{HMAC-SHA1}{497cd9fc}{zzWlVQ==}",
    "openid.signed" => "assoc_handle,claimed_id,identity,mode,ns,ns.sreg,op_endpoint,response_nonce,return_to,signed,sreg.email,sreg.fullname,sreg.nickname"}

end


class OpenID::Association
  def get_message_signature(params)
    return 'abcdefghijklmnopqrstuvwxyz'
  end
end

Given /^that I have an incomplete OpenID$/ do
  OpenIdAuthentication::Association.create!(
    :handle => '{HMAC-SHA1}{497cd9fc}{zzWlVQ==}',
    :server_url => 'http://www.myopenid.com/server',
    :lifetime => 1209600, :issued => 1232922430, :assoc_type => 'HMAC-SHA1',
    :secret => 'C;l#####.dX?L')
  visit '/sessions', :post, {
      "openid.claimed_id" => "http://tomk32.myopenid.com/",
      "openid.mode" => "id_res",
      "openid.return_to" => "http://www.example.com/sessions?_method=post&open_id_complete=1",
      "openid.sig" => "abcdefghijklmnopqrstuvwxyz",
      "openid.ns" => "http://specs.openid.net/auth/2.0",
      "openid.op_endpoint" => "http://www.myopenid.com/server",
      "action" => "create",
      "_method" => "post",
      "openid.response_nonce" => "2009-01-26T18:23:20ZAP1WoW",
      "controller" => "sessions",
      "openid.identity" => "http://tomk32.myopenid.com/",
      "open_id_complete" => "1",
      "openid.assoc_handle" => "{HMAC-SHA1}{497cd9fc}{zzWlVQ==}",
      "openid.signed" => "assoc_handle,claimed_id,identity,mode,ns,op_endpoint,response_nonce,return_to,signed"}
end


Then /^I should have a user account$/ do
  assert session[:user_id]
end

Then /^I should have a identity$/ do
  assert session[:identity_id]
end