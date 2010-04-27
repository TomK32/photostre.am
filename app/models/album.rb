class Album
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String, :required => true
  field :permalink, :type => String, :required => true
  field :description, :type => String
  field :description_html, :type => String
  field :status, :type => String, :required => true, :default => 'published'
  field :key_photo_id, :type => String
  field :parent_id, :type => String, :default => nil

  scope :published, :where => {:status => 'published'}
  scope :latest, :order_by => [:updated_at, 'desc']
  scope :for_select, :select => 'id, title'
  scope :roots, where({:parent_id => nil})
  embed_many :related_photos
  alias_attribute :photos, :related_photos


  index :permalink, :unique => true

  embedded_in :website, :inverse_of => :albums

  before_validate :denormalize_description
  before_validate :set_key_photo
  before_validate :set_permalink

  validates_presence_of :title, :permalink

  STATUSES = %w(published draft deleted)
  STATUSES.each do |s|
    define_method("#{s}?".to_sym) { status == s}
    scope s.to_sym, :where => {:status => s}
  end

  validate(:status) do
    errors.add(:status, 'invalid') if ! STATUSES.include?(self.status.to_s)
    if website.albums.collect(&:permalink) != website.albums.collect(&:permalink).uniq
      errors.add(:permalink, 'duplicate')
    end
  end

  def key_photo
    @key_photo = self.related_photos.find(key_photo_id) if self.key_photo_id
    @key_photo ||= self.related_photos.first
    @key_photo
  end
  def key_photo_url(size, default = 'album.png')
    return default if key_photo.nil?
    key_photo.photo_url(default) || default
  end

  def parent=(other_album)
    self.parent_id = other_album.id
  end
  def parent
    website.albums.find(parent_id) if parent_id
  end

  def denormalize_description
    self.description_html = textilize(html_escape(self.description))
  end

  def set_key_photo
    if self.key_photo.nil? and self.related_photos.first
      self.key_photo_id = self.related_photos.first.id
    end
  end
  def set_permalink
    if self.title and self.permalink.blank?
      permalink = self.title.to_permalink.strip
      permalink_index = nil
      permalinks = website.albums.collect(&:permalink)
      while permalinks.include?([permalink, permalink_index].compact.join('-'))
        permalink_index ||= 0
        permalink_index += 1
      end
      self.permalink = [permalink, permalink_index].compact.join('-')
    end
  end

end
