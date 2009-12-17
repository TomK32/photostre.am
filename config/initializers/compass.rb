require 'compass'
# If you have any compass plugins, require them here.
Compass.configuration.parse(File.join(Rails.root, "config", "compass.config"))
Compass.configuration.environment = RAILS_ENV.to_sym
Compass.configuration.css_dir = File.join('themes', 'default', 'public', 'stylesheets')
Compass.configure_sass_plugin!
