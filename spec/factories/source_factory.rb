Factory.define :source do |source|
  source.title 'some source'
  source.user_id { (User.first || Factory(:user)).id }
  source.username { 'user%i' % User.count}
end

Factory.define :source_flickr_account, :parent => :source, :class => Source::FlickrAccount do |source|
  source.flickr_nsid { '12345%2i@N02' % User.count}
end