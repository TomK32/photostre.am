Factory.define :user do |user|
  user.login {'User%i' % User.count}
  user.email {'user%s@example.com' % User.count.to_s}
end