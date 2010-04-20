class SourceFlickrAccountWorker
  def self.update_data(options)
    source = User.where({'sources._id' => options[:id]}).first.sources.find(options[:id])
    return if source.updating?
    begin
      source.update_data
    rescue RuntimeError => ex
      # possibly run out of memory, root knows
      # but just let's kick another workling
      source.update_attributes(:status => 'active')
      source.call_worker
    end
  end
end