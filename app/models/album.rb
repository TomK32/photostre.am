class Album < ActiveRecord::Base
  acts_as_category
  
  named_scope :published, :conditions => {:state => 'published'}
  named_scope :latest, :order => 'updated_at DESC'
  named_scope :for_select, :select => 'id, title'
  
  has_permalink :title, :scope => :website_id
  belongs_to :key_photo, :class_name => 'Photo'
  belongs_to :website
  has_and_belongs_to_many :photos
  validates_presence_of :website_id, :title
  
  include AASM
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :published
  aasm_state :deleted
  

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
