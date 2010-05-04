# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  attr_accessor :title, :title_in_content
  def title(text, in_content = true)
    @title = text
    @title_in_content = in_content
  end

  def page_title(string = nil)
    return current_website.title if request.path == current_website.root_path
    string ||= :"#{controller_name}.#{action_name}.page_title"
    if @title.blank? and params[:id]
      object = resource rescue nil
      (@title = t(string, :title => object.title, :default => object.title) if object and object.title) rescue nil
    else
      @title = t(string, :default => @title||'')
    end
    [@title, (current_website.title || t(:'app.title'))].reject{|a|a.blank?}.compact.join(' // ')
  end

  def meta_tags(object = nil)
    object ||= resource if params[:id] and defined?(resource) rescue nil
    return if object.nil?
    [:meta_geourl, :meta_keywords, :meta_description].each do |method|
      if object.respond_to?(method) and ! object.send(method).blank?
        yield(method, [object.send(method)].flatten.join(', '))
      end
    end
  end
  def javascript_dom_ready(js = '')
    content_for :javascript do
      "$(document).ready(function(){\n\t" <<
      js <<
      "\n})"
    end
  end
  def next_previous_links(collection, separator = " ")
    result = []
    if collection.previous_page
      result << link_to(collection.previous_page, {:page => collection.previous_page}, :class => 'previous')
    end
    if collection.next_page
      result << link_to(collection.next_page, {:page => collection.next_page}, :class => 'next')
    end
    return result.join(separator)
  end
end
