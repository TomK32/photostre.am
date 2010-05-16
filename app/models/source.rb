class Source
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, :type => String, :default => 'active'
  field :title, :type => String
  field :username, :type => String
  field :authenticated_at, :type => DateTime
  field :last_updated_at, :type => DateTime
  field :is_pro, :type => Boolean
  field :error_messages, :type => Array

  has_many_related :photos
  embedded_in :user, :inverse_of => :sources
#  index [:username, :_type], :unique => true

  ACTIVE_TYPES = AVAILABLE_TYPES = [['Flickr.com', 'Source::FlickrAccount']]
  STATUSES = %w(inactive active deleted updating)
  STATUSES.each do |s|
    define_method("#{s}?".to_sym) { status == s}
    scope s.to_sym, :where => {:status => s}
  end

#  validates_presence_of :title
#  validates_length_of :title, :minimum => 3

  scope :recent, :order_by => 'last_updated_at DESC'
  scope :active, :where => {:status => 'active'}

  def call_worker
    false # implement yourself goddamn it
  end

  def source_type=(source_type)
    self.attributes[:_type] = source_type if AVAILABLE_TYPES.collect{|t|t[0]}.include?(source_type)
  end

  def source_type
    self.attributes[:_type].to_s
  end
  def source_title
    AVAILABLE_TYPES.each do |source_t|
      return source_t[0] if source_t[1] = source_type
    end
  end
  def authenticated?
    ! authenticated_at.blank?
  end

  def photostream_url; end
  def profile_url; end

  def sync_websites
    raise 'Source must embed :albums for this to work' if ! self.respond_to?(:albums)
    # First sync all websites, that's creating/updating albums
    Website.where(:source_ids => self.id).each do |website|
      self.albums.each do |remote_album|
        album = website.albums.where(:remote_id => remote_album.remote_id).first
        if album.nil?
          album = Album.new(:title => remote_album.title, :description => remote_album.description, :remote_id => remote_album.remote_id)
          website.albums << album
          album.save
        end
        photos_map = {}
        photos = Photo.where(:source_id => self.id, :remote_id => {'$in' => remote_album.remote_photo_ids})
        photos.collect{|p| photos_map[p.remote_id] = p.id }
        remote_album.remote_photo_ids.each do |remote_photo_id|

          if album.photos.where(:photo_id => photos_map[remote_photo_id]).first.nil?
            related_photo = RelatedPhoto.new(:photo_id => photos_map[remote_photo_id])
            album.photos << related_photo
            related_photo.set_permalink(photos.select{|p|p.id == photos_map[remote_photo_id]}[0].title.to_permalink)
            related_photo.save!
          end
        end
        album.save!
      end
    end
  end
end
