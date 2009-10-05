Factory.define :website do |website|
  website.site_title 'my portfolio'
  website.domain {'example%i.com' % Website.count }
end

Factory.define :website_with_albums_and_photos, :parent => :website do |website|
  website.albums do |website|
    album = Factory.build(:album)
    album.photos = (0..4).collect{ Factory(:photo) }
    [album, Factory.build(:album)]
  end
end
  