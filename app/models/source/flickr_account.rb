require 'flickr_fu'

class Source::FlickrAccount < Source

  field :token, :type => String
  field :flickr_nsid, :type => String

#  validates_presence_of :flickr_nsid
  after_create :call_worker
  before_validation :set_title
  
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
    options = FLICKR_CONFIG
    options.merge!({:token => Flickr::Auth::Token.new(token)}) unless token.blank?
    @flickr ||= Flickr.new(options)
  end
  
  def photostream_url
    "http://flickr.com/photos/%s" % flickr_nsid
  end

  def profile_url
    "http://flickr.com/people/%s" % flickr_nsid
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
    return if self.deleted?
    return unless self.authenticated?
    self.update_attribute(:status, 'active') if self.updating?
    SourceFlickrAccountWorker.asynch_update_data(:id => self.id) rescue nil
  end

  # TODO import and create albums
  def update_data
    return unless authenticated?
    errors = []
    logger.debug "updating data for %s: %s" % [source_title, username]
    page = 1
    per_page = 200
    TagList.delimiter = ' '
    while (page <= (person.photo_count / per_page) + 1)
      logger.info "updating page %i for %s" % [page, self.title]
      logger.debug "getting image %s to %s for %s" % [page * per_page, (page+1) * per_page, username]
      # TODO change to use search with min_date and also to get private photos
      #      with extras url_o
      # flickr_photos = flickr.photos.search(:user_id => self.flickr_nsid, :min_upload_date => self.photos.first(:))
      flickr_photos = person.public_photos(:per_page => per_page, :page => page)
      existing_photos = Photo.find(:all, :conditions => {:remote_id => flickr_photos.collect{|p| p.id }}, :select => :remote_id).collect{|p| p.remote_id }
      flickr_photos.reject!{|p| existing_photos.include?(p.id)}
      flickr_photos.each do |photo|

        next if photo.media != 'photo'
        local_photo = self.photos.find_by_remote_id(photo.id) || self.photos.new
        next unless local_photo.new_record?
        local_photo.attributes = {
          :title => photo.title,
          :remote_id => photo.id,
          :taken_at => photo.taken_at,
          :created_at => photo.uploaded_at,
          :updated_at => photo.updated_at,
          :description => photo.description,
          :tag_list => TagList.new(photo.tags, {:parse => true}),
          :machine_tag_list => TagList.new(photo.machine_tags, {:parse => true}),
          :web_url => photo.url_photopage,
          :photo_url => photo.url(:original) || photo.url(:medium),
          :thumbnail_url => photo.url(:thumbnail),
          :medium_url => photo.url(:medium),
          :icon_url => photo.url(:square),
          :username => photo.owner_name,
          :user_id => self.user.id,
          :public => photo.is_public == '1'
        }
        unless local_photo.save(false)
          logger.debug("Couldn't save photo %s: %s" % [photo.id, photo.url_photopage])
          errors << local_photo.errors
        end
      end
      page += 1
    end
    return errors
  end
end