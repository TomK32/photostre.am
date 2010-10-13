source :gemcutter

gem 'rails'#, :git => 'git://github.com/rails/rails.git', :ref => '9e081caee74e6d08035a8835899dcc566536a871'
gem 'rack'
#gem 'rack-test'
#gem 'rack-openid'
gem 'thor'

# Database
gem 'mongo'
gem 'bson_ext'

#gem 'builder'
gem 'mongoid', :git => 'git://github.com/mongoid/mongoid.git'

# For monitoring and background processes
gem 'god'
gem 'daemons'
gem 'navvy'#, :git => 'git://github.com/TomK32/navvy.git'


# Deployment
gem 'capistrano'

# Views and controller related
gem 'haml'
gem 'RedCloth'
gem 'compass'
gem 'compass-960-plugin', :require => 'ninesixty'

gem 'inherited_resources'
gem 'will_paginate', :branch => 'rails3'

gem 'exception_notification', :git => 'git://github.com/rails/exception_notification.git', :require => 'exception_notifier'

# Testing
group :development do
  gem "autotest"
  gem "cucumber"
  gem "cucumber-rails"
  gem "rspec"
  gem "rspec-core"
  gem "rspec-rails"
  gem "rspec-mocks"
  gem "rspec-expectations"
  gem "factory_girl_rails"
  gem "shoulda"
  gem "mongoid-rspec", :git => "http://github.com/evansagge/mongoid-rspec.git"
  gem "webrat"
end

# Other
gem 'tomk32-flickr_fu', :require => 'flickr_fu', :git => 'git://github.com/TomK32/flickr_fu.git'
gem 'ruby-openid', :require => 'openid'

# some weird mac specific requirement
group :development do
  gem 'system_timer'
end
