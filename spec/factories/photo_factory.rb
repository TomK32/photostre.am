Factory.define :photo do |photo|
  photo.title 'self-portrait'
  photo.source_id { (Source.first || Factory(:source)).id}
  photo.remote_id { Photo.count.to_s }
  photo.user_id { (User.first || Factory(:user)).id }
  photo.web_url {'http://example.com/photo%i' % Photo.count}
  photo.photo_url {'http://example.com/photo%i.jpg' % Photo.count}
  photo.thumbnail_url {'http://example.com/photo%i_thumb.jpg' % Photo.count}
  photo.medium_url {'http://example.com/photo%i_medium.jpg' % Photo.count}
end