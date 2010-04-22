class SourceFlickrAccountWorker
  def self.update_data(options)
    source = User.where({'sources._id' => options[:id]}).first.sources.find(options[:id])
    source.update_data
  end
end