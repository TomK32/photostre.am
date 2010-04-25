Factory.define :user do |user|
  user.login {'User%i' % User.count}
  user.email {'user%s@example.com' % User.count.to_s}
end

Factory.define :user_with_source, :parent => :user do |user|
  user.sources { [Factory.build(:source)] }
end