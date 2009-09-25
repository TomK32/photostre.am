Factory.define :photo do |photo|
  photo.title 'self-portrait'
  photo.source { Source.first || Factory(:source)}
  photo.remote_id { Photo.count.to_s }
  photo.user { User.first || Factory(:user) }
  photo.web_url 'http://example.com/photo.jpg'
  photo.photo_url 'http://example.com/photo.jpg'
  photo.thumbnail_url 'http://example.com/photo.jpg'
end