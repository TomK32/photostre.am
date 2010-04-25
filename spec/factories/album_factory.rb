Factory.define :album do |album|
  album.title {'My album ' + Album.count.to_s}
  album.status 'published'
  album.body 'These are photos from my trip to Helsinki'
  album.website { Website.first || Factory(:website)}
end
Factory.define :album_with_photos, :parent => :album do |album|
  album.photos { (0..5).collect{Factory.build(:related_photo)} }
end
