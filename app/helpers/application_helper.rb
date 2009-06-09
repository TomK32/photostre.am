# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  attr_accessor :site_title, :meta_keywords

  def title(text)
    @title = text
  end

  def page_title
    [@title, (@site_title || t(:'app.title'))].reject{|a|a.blank?}.compact.join(' // ')
  end

  def meta_keywords
    return if @meta_keywords.blank?
    @meta_keywords = @meta_keywords.split(',') if @meta_keywords.is_a?(String)
    @meta_keywords ||= []
    keywords = (@meta_keywords + current_website.meta_keywords.split(',')).compact
    keywords.map{|k| k.squish }.join(',')
  end
end
