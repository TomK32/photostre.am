# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  attr_accessor :title, :title_in_content
  def title(text, in_content = true)
    @title = text
    @title_in_content = in_content
  end

  def page_title(string = nil)
    string ||= :"#{controller_name}.#{action_name}.page_title"
    if @title.blank? and params[:id] and defined?(resource)
      @title = t(string, :title => resource.title, :default => resource.title)
    else
      @title = t(string, :default => @title||'')
    end
    [@title, (current_website.title || t(:'app.title'))].reject{|a|a.blank?}.compact.join(' // ')
  end

  def meta_tags(object = nil)
    object ||= resource if params[:id] and defined?(resource)
    return if object.nil?
    [:meta_geourl, :meta_keywords, :meta_description].each do |method|
      if object.respond_to?(method) and ! object.send(method).blank?
        yield(method, [object.send(method)].flatten.join(', '))
      end
    end
  end
end
