class SourceFlickrWorker < Workling::Base
  def update_data(options)
    Source::Flickr.find(options[:id]).update_data
  end
end