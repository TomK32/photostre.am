require 'navvy'
require 'navvy/job/mongoid'

Navvy.configure do |config|
  config.logger = Navvy::Logger.new(Rails.root.join('log', 'navvy.log'))
  config.job_limit = 1
end
