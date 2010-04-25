# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require 'factory_girl'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails.root)
require 'rails/test_help'
require 'rspec/rails'
require 'shoulda'
require 'shoulda/active_model'
require 'mongoid'
require 'webrat'
require 'rspec/expectations'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Rspec.configure do |config|
  config.include Rspec::Matchers
  config.include Shoulda::ActiveModel::Matchers
  
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  
  
  config.mock_with :rspec
  config.before(:each) do
    User.delete_all
    Website.delete_all
    Photo.delete_all
#    Mongoid.master.collections.each(&:drop)
  end

end

