Factory.define :user do |user|
  user.login {'User%s' % User.count.to_s}
  user.email {'user%s@example.com' % User.count.to_s}
end