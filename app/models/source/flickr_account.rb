require 'flickr_fu'

class Source::FlickrAccount < Source


  validates_presence_of :username
  after_save :call_worker
  
  def validate
    begin
      user = flickr.people.find_by_username(self.username)
    rescue Flickr::Errors::UserNotFound
      begin
        user = flickr.people.find_by_id(self.username)
      rescue Flickr::Errors::UserNotFound
        errors.add 'username', 'not a flickr account'
      end
      errors.add 'username', 'not a flickr account'
    end
    username = user.nsid if user
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
    SourceFlickrWorker.asynch_update_data(:id => self.id, :username => self.username) if self.active?
  end

  def update_data
  end

end