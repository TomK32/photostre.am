Factory.define :source do |source|
  source.title 'some source'
  source.user { User.first || Factory(:user) }
#  source.username { source.user.login }
end

Factory.define :source_flickr_account, :class => 'FlickrAccount' do |source|
  source.flickr_nsid { '12345%2i@N02' % User.count}
  source._type 'Source::FlickrAccount'
end