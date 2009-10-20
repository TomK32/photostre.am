Factory.define :identity do |identity|
  identity.identity_url {'http://openid.example.com/' + Identity.count.to_s }
  identity.user { User.first || Factory(:user)}
end