require 'flickr_fu'

class Source::FlickrAccount < Source
  field :token, :type => String
  field :flickr_nsid, :type => String
  embed_many :albums, :class_name => 'Source::FlickrAccount::Album'

  validates_presence_of :flickr_nsid
  after_create :call_worker
  before_validate :set_title

  def validate_on_create
    errors.add 'username', 'not a flickr account' unless set_nsid
  end

  def set_title
    self.title ||= 'Flickr.com %s' % self.username
  end
  def set_nsid
    return true unless self.flickr_nsid.blank?
    begin
      flickr_user = flickr.people.find_by_username(self.username)
    rescue Flickr::Errors::UserNotFound
      logger.debug "didn't find user by username, testing as email"
      begin
        flickr_user = flickr.people.find_by_email(self.username)
      rescue Flickr::Errors::UserNotFound
        logger.debug "didn't find user by email, testing as id"
        begin
          flickr_user = flickr.people.find_by_id(self.username)
        rescue Flickr::Errors::UserNotFound
          logger.debug "cannot find user by id"
        end
      end
    end
    if flickr_user
      self.username = flickr_user.username
      return self.flickr_nsid = flickr_user.nsid
    end
    return false
  end

  def flickr(token = nil)
    return @flickr if @flickr
    options = FLICKR_CONFIG
    options.merge!({:token => Flickr::Auth::Token.new(token)}) unless token.blank?
    @flickr = Flickr.new(options)
  end

  def photostream_url
    "http://www.flickr.com/photos/%s" % flickr_nsid
  end

  def profile_url
    "http://www.flickr.com/people/%s" % flickr_nsid
  end

  def person
    @person ||= flickr.people.find_by_id(self.flickr_nsid)
  end

  def before_validation
    self.title = self.username if self.title.blank?
  end

  def authentication_url
    flickr.auth.url(:read)
  end

  def authenticated?
    ! (token.blank? or authenticated_at.blank?)
  end

  def authenticate(frob)
    flickr.auth.frob = frob
    unless flickr.auth.token.nil? or flickr.auth.token.token.blank?
      #Rails.logger.debug("authenticated %s: %s with frob: %s" % [self.source_type, self.username, frob])
      self.token = flickr.auth.token.token
      self.authenticated_at = Time.now
      @flickr = nil unless self.new_record? # to create a new one with the right token
      return true
    end
    return false
  end

  def call_worker
#    return if self.deleted?
    return unless self.authenticated?
    return unless active?
    self.update_attributes(:status => 'updating')
    Navvy::Job.enqueue(SourceFlickrAccountWorker, :update_data, {:id => self.id})
  end

  # TODO import and create albums
  def update_data
    return unless authenticated?
    execute_with_rescue do
      page = 0
      per_page = 200
      flickr.photos.extras.merge!({:url_o => :original_url, :description => :description,
          :original_secret => :original_secret})
      begin
        page += 1
        flickr_photos = flickr.photos.search(:per_page => per_page, :page => page,
            :user_id => 'me', :auth_token => self.token)
        flickr_photos_count = flickr_photos.size
        existing_photos = Photo.where(:source_id => self.id,
            :remote_id.in => flickr_photos.collect{|p| p.id }
          ).only(:remote_id).collect{|p| p.remote_id.to_s }
        flickr_photos.reject!{|p| existing_photos.include?(p.id.to_s) }

        flickr_photos.each do |photo|

          next if photo.media != 'photo'
          photo_attr = {
            :title => photo.title,
            :remote_id => photo.id.to_i,
            :taken_at => photo.taken_at,
            :created_at => photo.uploaded_at,
            :updated_at => photo.updated_at,
            :tags => photo.tags.split(' '),
            :web_url => 'http://www.flickr.com/photos/%s/%s' % [self.flickr_nsid, photo.id],
            :machine_tags => photo.machine_tags.split(' '),
            :description => photo.description,
            :photo_urls => {
                :o => photo.original_url,
                :m => photo.url(:medium),
              },
            :status => photo.public? ? 'public' : 'private',
            :original_secret => photo.original_secret,
            :user_id => self.user.id,
            :source_id => self.id
          }
          Photo.create(photo_attr)
        end
      end while page < flickr_photos.pages
    end
    self.update_attributes(:last_updated_at => Time.now)
    self.update_attributes(:status => 'active')
  end

  def import_albums
    # TODO this is quite expensive as I think it writes all alubms again on reimport
    # but otoh we don't do it that often.
    execute_with_rescue do
      photosets = flickr.photosets.get_list(:user_id => self.flickr_nsid, :auth_token => self.token)
      photosets.each do |photoset|
        album = self.albums.where(:remote_id => photoset.id.to_i).first
        if album.nil?
          album = Source::FlickrAccount::Album.new({:title => photoset.title,
            :remote_id => photoset.id.to_i, :description => photoset.description, :remote_photo_ids => []})
          self.albums << album
        end
        album.remote_photo_ids = []
        page = 0
        per_page = 500
        begin
          page += 1
          photoset_photos = photoset.get_photos(:user_id => self.flickr_nsid, :auth_token => self.token, :page => page, :per_page => per_page)
          album.remote_photo_ids += photoset_photos.collect{|p|p.id.to_i}
        end while photoset_photos.size == per_page
        album.save
      end
      self.save!
    end
  end

  # Rescues any Flickr errors that might come up in the block
  # and save them in the account's error_messages
  def execute_with_rescue(&block)
    begin
      yield block
    rescue Flickr::Error => ex
      self.error_messages ||= []
      self.error_messages << {:date => Time.now, :msg => ex.message}
      if ex.message.match(/(User not found|Invalid auth token)/)
        self.status = 'inactive'
      end
      self.save
      return
    end
  end
end

class Source::FlickrAccount::Album
  include Mongoid::Document
  field :title, :type => String
  field :remote_id, :type => Integer
  field :description, :type => String
  field :remote_photo_ids, :type => Array
  embedded_in :source, :inverse_of => :albums
  validates_presence_of :remote_id
end
