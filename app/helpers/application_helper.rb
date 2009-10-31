# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  attr_accessor :title, :title_in_content

  def title(text, in_content = true)
    @title = text
    @title_in_content = in_content
  end

  def page_title
    [@title, (current_website.site_title || t(:'app.title'))].reject{|a|a.blank?}.compact.join(' // ')
  end

  def meta_tags(object = nil)
    object ||= current_object if defined?(current_object)
    return if object.nil?
    [:meta_geourl, :meta_keywords, :meta_description].each do |method|
      if object.respond_to?(method) and ! object.send(method).blank?
        yield(method, object.send(method))
      end
    end
  end
end
