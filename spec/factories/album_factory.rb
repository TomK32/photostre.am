Factory.define :album do |album|
  album.title {'My album ' + Album.count.to_s}
  album.state 'published'
  album.body 'These are photos from my trip to Helsinki'
  album.website_id { (Website.first || Factory(:website)).id }
end
