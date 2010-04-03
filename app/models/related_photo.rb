# In order to store the photos in their own collection and still have
# them with more than just an array of ids in the Website, Album and Page
# objects we have an extra class, rebuilding what in SQL would be a join table
class RelatedPhoto
  include Mongoid::Document

  belongs_to_related :photo
  
  field :position, :type => Integer
  field :permalink, :type => String
  
  index :permalink, :unique => true
  key :permalink
  
  scope :published, :where => {:status => 'published'}

end