require 'mongoid'
File.open(Rails.root.join('config/database.mongo.yml'), 'r') do |f|
  @settings = YAML.load(f)[Rails.env]
end

Mongoid.configure do |config|
  name = @settings["database"]
  host = @settings["host"]
  config.master = Mongo::Connection.new(host, 27017, :logger => Rails.logger).db(name)
end