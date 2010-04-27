module PhotosHelper
  def source_link(photo)
    if photo.source
      raw link_to(photo.source.source_title, photo.web_url)
    end
  end
end