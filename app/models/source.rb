class Source < ActiveRecord::Base
  has_many :photos
  belongs_to :user
  
  ACTIVE_TYPES = AVAILABLE_TYPES = [['Flickr.com', 'Flickr']]
  
  validates_presence_of :type
  validates_presence_of :user_id
  validates_presence_of :title
  
  def source_type=(source_type)
    self.type = source_type if AVAILABLE_TYPES.collect{|t|t[0]}.include?(source_type)
  end

  def source_type
    self.type.to_s
  end
  
end
