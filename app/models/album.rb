class Album
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, :type => String, :default => 'published'

  named_scope :published, :where => {:status => 'published'}
  named_scope :latest, :order_by => [:updated_at => :desc]
  named_scope :for_select, :select => 'id, title'

  belongs_to :website, :inverse_of => :albums
#  has_and_belongs_to_many :photos
#  validates_presence_of :website_id, :title


  before_validation :denormalize_body
  before_validation :set_key_photo

  def denormalize_body
    self.body_html = textilize(self.body)
  end

  def set_key_photo
    if self.key_photo.nil? and self.key_photo_id.nil?
      self.key_photo = self.photos.first
    end
    if self.key_photo_id_changed?
      self.key_photo_thumbnail_url = self.key_photo.thumbnail_url
      self.key_photo_medium_url = self.key_photo.medium_url
    end
  end

end
