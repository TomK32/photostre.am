require 'compass'
# If you have any compass plugins, require them here.
Compass.add_project_configuration(Rails.root.join("config", "compass.config"))
Compass.configuration.environment = :production
Compass.configuration.css_dir = File.join('themes', 'system', 'public', 'stylesheets')
Compass.configure_sass_plugin!
