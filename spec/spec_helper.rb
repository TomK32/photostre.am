# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require 'factory_girl'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails.root)
require 'rails/test_help'
require 'rspec/rails'
require 'shoulda'
require 'shoulda/active_model'
require 'shoulda/active_model/matchers'
require 'mongoid'
require 'webrat'
require 'rspec/expectations'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Rspec.configure do |config|
  config.include Rspec::Matchers
  config.include Shoulda::ActiveModel::Matchers
  
  
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
#  config.before(:each) do
#    Mongoid.master.collections.each(&:drop)
#  end

end

