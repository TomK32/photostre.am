class SourceFlickrAccountWorker < Workling::Base
  def update_data(options)
    source = Source::FlickrAccount.find(options[:id])
    if source.updating?
      return
    else
      source.update_attribute(:state, 'updating')
      begin
        source.update_data
      rescue RuntimeError => ex
        # possibly run out of memory, root knows
        # but just let's kick another workling
        source.update_attribute(:state, 'active')
        source.call_worker
      end
    end
  end
end