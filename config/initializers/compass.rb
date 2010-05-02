require 'compass'
# If you have any compass plugins, require them here.
Compass.configuration.parse(File.join(Rails.root, "config", "compass.config"))
Compass.configuration.environment = :production
Compass.configuration.css_dir = File.join('themes', 'system', 'public', 'stylesheets')
Compass.configure_sass_plugin!
