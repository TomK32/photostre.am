module WebsiteHelper
  attr_accessor :site_title, :page_title

  def site_title
    "%s // %s" % [page_title, current_website.site_title]
  end
end
