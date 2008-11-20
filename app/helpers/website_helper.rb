module WebsiteHelper
  attr_accessor :site_title, :page_title, :meta_keywords

  def site_title
    "%s // %s" % [page_title, current_website.site_title]
  end
  
  def meta_keywords
    @meta_keywords.split(',') if @meta_keywords.is_a?(String)
    keywords = [@meta_keywords, current_website.meta_keywords.split(',')].compact
    keywords.map{|k|k.}.join(',')
  end
end
