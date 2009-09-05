# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  attr_accessor :title

  def title(text)
    @title = text
  end

  def page_title
    [@title, (current_website.site_title || t(:'app.title'))].reject{|a|a.blank?}.compact.join(' // ')
  end

  def meta_tags(object)
    [:meta_geourl, :meta_keywords, :meta_description].each do |method|
      if object.respond_to?(method)
        content_for method do
          object.send(method)
        end
      end
    end
    
  end
end
