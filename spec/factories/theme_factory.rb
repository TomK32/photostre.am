Factory.define :theme do |theme|
  theme.name 'black theme'
  theme.directory 'black-theme'
  theme.description 'A very black theme'
  theme.status 'public'
  theme.author_id {(User.first || Factory(:user, :login => 'theme_author')).id }
  theme.user_id {(User.first || Factory(:user)).id }
end

Factory.define :public_theme, :parent => :theme do |theme|
  theme.status 'public'
end

Factory.define :paid_theme, :parent => :theme do |theme|
  theme.status 'paid'
end