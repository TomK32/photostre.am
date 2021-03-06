require 'mongoid'
File.open(Rails.root.join('config/database.mongo.yml'), 'r') do |f|
  @settings = YAML.load(f)[Rails.env]
end

name = @settings["database"]
host = @settings["host"]
user = @settings["user"]
password = @settings["password"]

Mongoid.configure do |config|
  config.master = Mongo::Connection.new(host, 27017).db(name)
  if ! user.blank? and ! password.blank?
    config.master.authenticate(user, password)
  end
end

