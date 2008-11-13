class SourceFlickrAccountWorker < Workling::Base
  def update_data(options)
    Source::FlickrAccount.find(options[:id]).update_data
  end
end