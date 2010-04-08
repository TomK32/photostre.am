class Album
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String, :required => true
  field :permalink, :type => String, :required => true
  field :body, :type => String
  field :body_html, :type => String
  field :status, :type => String, :required => true, :default => 'published'
  field :key_photo_id, :type => String
  field :parent_id, :type => String

  scope :published, :where => {:status => 'published'}
  scope :latest, :order_by => [:updated_at, 'desc']
  scope :for_select, :select => 'id, title'
  embed_many :related_photos
  
  index :permalink, :unique => true

  embedded_in :website, :inverse_of => :albums
#  has_and_belongs_to_related_many :photos
#  validates_presence_of :website_id, :title
  validates_uniqueness_of :permalink


  before_validate :denormalize_body
  before_validate :set_key_photo


  STATUSES = %w(published draft deleted)
  STATUSES.each do |s|
    define_method("#{s}?".to_sym) { status == s}
    scope s.to_sym, :where => {:status => s}
  end

  def key_photo
    @key_photo = self.related_photos.find(key_photo_id) if self.key_photo_id
    @key_photo ||= self.related_photos.first
    @key_photo ||= @key_photo.photo if @key_photo and @key_photo.photo
    @key_photo
  end
  def key_photo_url(size, default = 'album.png')
    return default if key_photo.nil?
    key_photo.photo_url(default) || default
  end

  def denormalize_body
    self.body_html = textilize(html_escape(self.body))
  end

  def set_key_photo
    if self.key_photo.nil? and self.related_photos.first
      self.key_photo_id = self.related_photos.first.id
    end
  end

end
