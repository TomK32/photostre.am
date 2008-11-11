class Source::Flickr < Source
  validates_presence_of :username
  after_save :call_worker

  def before_validation
    self.title ||= self.username
  end  

  def call_worker
    SourceFlickrWorker.asynch_  update_data(:id => self.id, :username => self.username) if self.active?
  end

  def update_data
    
  end

end