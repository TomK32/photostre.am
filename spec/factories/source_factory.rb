Factory.define :source do |source|
  source.title 'some source'
  source.website { Website.first || Factory(:website) }
  source.user { User.first || Factory(:user) }
end

Factory.define :source_flickr_account, :parent => :source, :class => Source::FlickrAccount do |source|
  source.username { 'user%i' % User.count}
end