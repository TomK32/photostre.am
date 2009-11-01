Factory.define :website do |website|
  website.site_title 'my portfolio'
  website.domain {'example%i.com' % Website.count }
  website.state 'active'
end

Factory.define :website_with_photos, :parent => :website do |website|
  website.photos { (0...20).collect{ Factory(:photo)} }
end

Factory.define :website_with_albums_and_photos, :parent => :website_with_photos do |website|
  website.albums do |website|
    album = Factory.build(:album)
    album.photos = website.photos[0..4]
  end
end
  