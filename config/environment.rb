# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'rack/domain_dispatcher'
require 'rack/theme_static'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/models/source/ )

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'haml-edge', :lib => 'haml', :version => '>= 2.3.60'
  config.gem 'compass', :version => '>= 0.8.17'
  config.gem 'RedCloth'
  config.gem "aasm"
  config.gem "factory_girl"
#  config.gem "memcache-client"
  config.gem "tomk32-flickr_fu", :lib => 'flickr_fu'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :en

  config.middleware.use(Rack::DomainDispatcher)
  config.middleware.use(Rack::ThemeStatic)
end

