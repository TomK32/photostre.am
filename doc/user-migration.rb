#!/usr/bin/env ruby
# This only migrates the users, nothing else

require 'mongoid'
Mongoid.configure do |config|
  config.master = Mongo::Connection.new('173.203.242.105', 27017).db('photostream_production')
  config.master.authenticate('2bc42549', '39310af485e3e3ed69af3142')
end

class MUser
  include Mongoid::Document
  def _type; 'User'; end
  self.collection_name = 'users'
  has_many :sources
end
class MSource
  include Mongoid::Document
  def _type; 'Source'; end
  belongs_to :user, :inverse_of => :sources
end


User.all[3..-1].each do |u|
  mu = MUser.new({:id => BSON::ObjectID.new.to_s}.merge(
      u.attributes.delete_if {|k,v| v.blank? || %(id type state).include?(k)}))
  mu.attributes['type'] = 'User'
  mu.save!
  u.sources.each do |s|
    ms = MSource.new({:id => BSON::ObjectID.new.to_s}.merge(
      s.attributes.delete_if {|k,v| v.blank? || %(id type state user_id).include?(k)}))
    mu.sources << ms
    ms.save!
  end
end

# db.users.update({'sources._type': 'MSource'}, {$set: {'sources.$._type' : 'Source::FlickrAccount'}}, false, true)
# <