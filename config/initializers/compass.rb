require 'compass'
# If you have any compass plugins, require them here.
Compass.add_project_configuration(Rails.root.join("config", "compass.rb").to_s)
Compass.configuration.environment = Rails.env.to_sym
Compass.configure_sass_plugin!

