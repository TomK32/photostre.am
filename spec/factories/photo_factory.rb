Factory.define :photo do |photo|
  photo.title 'self portrait'
  photo.remote_id { Photo.count.to_s }
  photo.user_id { (Factory(:user_with_source)).id }
  photo.source_id { |p| p.user.sources.first.id }
  photo.web_url {'http://example.com/photo%i' % Photo.count}
  photo.photo_urls {
      {:original => 'http://example.com/photo%i.jpg' % Photo.count,
      :thumbnail => 'http://example.com/photo%i_thumb.jpg' % Photo.count,
      :medium_url => 'http://example.com/photo%i_medium.jpg' % Photo.count}
    }
end