Factory.define :album do |album|
  album.title {'My album ' + Album.count.to_s}
  album.status 'published'
  album.body 'These are photos from my trip to Helsinki'
  album.website { Website.first || Factory(:website)}
end
