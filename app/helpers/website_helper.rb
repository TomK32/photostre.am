module WebsiteHelper
  attr_accessor :site_title, :page_title, :meta_keywords

  def site_title
    [page_title, current_website.site_title].compact.join(' // ')
  end
  
  def meta_keywords
    @meta_keywords = @meta_keywords.split(',') if @meta_keywords.is_a?(String)
    @meta_keywords ||= []
    keywords = (@meta_keywords + current_website.meta_keywords.split(',')).compact
    keywords.map{|k| k.squish }.join(',')
  end
end
