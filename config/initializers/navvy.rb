require 'navvy'
require 'navvy/job/mongoid'

Navvy.configuration.logger = Rails.logger
Navvy.configuration.job_limit = 1
