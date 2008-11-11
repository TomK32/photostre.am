class Source::Flickr < Source
  validates_presence_of :username
  
  def before_validation
    self.title ||= self.username
  end
end