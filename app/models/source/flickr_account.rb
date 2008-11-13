require 'flickr_fu'

class Source::FlickrAccount < Source


  validates_presence_of :username
  after_save :call_worker
  
  def validate
    errors.add 'username', 'not a flickr account' unless set_username_to_nsid
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
    return self.flickr_nsid = flickr_user.nsid if user
    return false
  end

  def flickr
    @flickr ||= Flickr.new(FLICKR_CONFIG)
  end

  def before_validation
    self.title ||= self.username
  end
  
  
  def authentication_url
    flickr.auth.url(:write)
  end
  
  def authenticate(frob)
    flickr.frob = frob
    if flickr.auth.token
      self.update_attribute :token, flickr.token
      return true
    end
    return false
  end
  
  def call_worker
    SourceFlickrAccountWorker.asynch_update_data(:id => self.id) if self.active?
  end

  def update_data
    logger.debug "updating data for %s: %s" % [source_title, username]
  end

end