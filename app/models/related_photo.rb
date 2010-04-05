# In order to store the photos in their own collection and still have
# them with more than just an array of ids in the Website, Album and Page
# objects we have an extra class, rebuilding what in SQL would be a join table
class RelatedPhoto
  include Mongoid::Document
  include Mongoid::Timestamps

#  field :position, :type => Integer
  field :permalink, :type => String
  before_save :set_permalink

  belongs_to_related :photo
  embedded_in :website, :polymorphic => true, :inverse_of => :related_photos

#  key :permalink

  scope :published, :where => {:status => 'published'}

  def method_missing(method, *args, &block)
    self.photo.send(method, args, &block)
  end

  def set_permalink
    self.permalink = self.id if self.permalink.blank?
  end
end