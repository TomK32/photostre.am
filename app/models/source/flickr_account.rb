require 'flickr_fu'

class Source::FlickrAccount < Source

  validates_presence_of :username
  after_save :call_worker
  
  def validate
    errors.add 'username', 'not a flickr account' unless set_nsid
  end

  def set_nsid
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
    if user
      self.username = flickr_user.username
      return self.flickr_nsid = flickr_user.nsid
    end
    return false
  end

  def flickr
    options = FLICKR_CONFIG
    options.merge!({:token => Flickr::Auth::Token.new( token)}) unless token.blank?
    @flickr ||= Flickr.new(options)
  end
  
  def person
    @person ||= flickr.people.find_by_id(self.flickr_nsid)
  end

  def before_validation
    self.title ||= self.username
  end
  
  
  def authentication_url
    flickr.auth.url(:write)
  end
  
  def authenticated?
    ! (token.blank? or authenticated_at.blank?) 
  end
  
  def authenticate(frob)
    flickr.auth.frob = frob
    if flickr.auth.token
      logger.debug ("authenticated %s: %s with frob: %s" % [self.source_type, self.username, frob])
      self.token = flickr.auth.token.token
      self.authenticated_at = Time.now
      save
      @flickr = nil # to create a new with the right token
      return true
    end
    return false
  end
  
  def call_worker
    SourceFlickrAccountWorker.asynch_update_data(:id => self.id) if active? and authenticated?
  end

  def update_data
    return unless authenticated?
    errors = []
    logger.debug "updating data for %s: %s" % [source_title, username]
    page = 1
    per_page = 200
    while (page <= (person.photo_count / per_page) + 1)
#      logger.debug "getting image %s to %s for %s" % [page * per_page, (page+1) * per_page, username]
      flickr_photos = person.public_photos(:per_page => per_page, :page => page)
      existing_photos = Photo.find(:all, :conditions => {:remote_id => flickr_photos.collect{|p| p.id }}, :select => :remote_id).collect{|p| p.remote_id }
      flickr_photos.reject!{|p| existing_photos.include?(p.id)}
      flickr_photos.each do |photo|
        # TODO break if there's no new image
        next if photo.media != 'photo'
        local_photo = self.photos.find_by_remote_id(photo.id) || self.photos.new
        next unless local_photo.new_record?
        local_photo.attributes = {
          :title => photo.title,
          :remote_id => photo.id,
          :description => photo.description,
          :tag_list => photo.tags,
          :machine_tag_list => photo.machine_tags,
          :web_url => photo.url_photopage,
          :photo_url => photo.url(:original),
          :thumbnail_url => photo.url(:thumbnail),
          :username => photo.owner_name,
          :user_id => user_id,
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