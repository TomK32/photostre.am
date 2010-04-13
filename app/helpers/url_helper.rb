module UrlHelper
  def album_url_with_host(album, options = {})
    album_url(album.permalink, options.merge(:host => album.website.domain))
  end
  def photo_url_with_host(photo, options = {})
    if options.first.is_a?(Hash) and options.first[:album]
      album = options.first.delete(:album)
      options << {:host => album.website.domain}
      album_photo_url(album.permalink, photo.permalink, options)
    else
      photo_url(photo.permalink, options)
    end
  end
end
