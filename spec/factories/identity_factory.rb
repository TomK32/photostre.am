Factory.define :identity do |identity|
  identity.identity_url {'http://openid.example.com/' + Identity.count.to_s }
  identity.user_id { (User.first || Factory(:user)).id }
end