Factory.define :photo do |photo|
  photo.title 'self-portrait'
  photo.source { Source.first || Factory(:source)}
  photo.remote_id { Photo.count.to_s }
  photo.user { User.first || Factory(:user) }
  photo.web_url {'http://example.com/photo%i' % Photo.count}
  photo.photo_url {'http://example.com/photo%i.jpg' % Photo.count}
  photo.thumbnail_url {'http://example.com/photo%i_thumb.jpg' % Photo.count}
  photo.medium_url {'http://example.com/photo%i_medium.jpg' % Photo.count}
end