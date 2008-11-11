class Source < ActiveRecord::Base
  has_many :photos
  belongs_to :user
  
  ACTIVE_TYPES = [Flickr, 'Flickr.com']
  
  validates_presence_of :type
  validates_presence_of :user_id
  validates_presence_of :title
  
end
