# This configuration file works with both the Compass command line tool and within Rails.
# Require any additional compass plugins here.
require 'ninesixty'
project_type = :rails
project_path = Rails.env if defined?(Rails.env)
# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "themes/system/public/stylesheets"
sass_dir = "app/stylesheets/"
environment = Compass::AppIntegration::Rails.env
# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
