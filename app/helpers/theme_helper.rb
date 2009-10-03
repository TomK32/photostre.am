module ThemeHelper
  def theme_stylesheet_link_tag(*sources)
    stylesheet_link_tag(sources.map{|source| File.join('theme', source)})
  end
end
