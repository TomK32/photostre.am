Factory.define :source do |source|
  source.title 'some source'
  source.user_id { (User.first || Factory(:user)).id }
end

Factory.define :source_flickr_account, :parent => :source, :class => Source::FlickrAccount do |source|
  source.username { 'user%i' % User.count}
end