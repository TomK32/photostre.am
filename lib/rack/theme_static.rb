require 'rack/utils'

module Rack
  class ThemeStatic < Rails::Rack::Static
    def call_with_theme(env)
      path = (env['REQUEST_PATH'] || env['PATH_INFO']).chomp()
      if(path =~ /^\/themes\/.*?\/screenshot.png/)
        @file_server = ::Rack::File.new(::File.join(Rails.root, 'themes'))
      end
      if(path =~ /^\/(javascript|images|stylesheets)/)
        website = Website.find_by_domain(env['SERVER_NAME'])
        website ||= Website.find_by_domain(env['SERVER_NAME'].gsub(/^www\./, ''))
        if website
          @file_server = ::Rack::File.new(::File.join(Rails.root, 'themes', website.theme_path, "public"))
        end
      end
      call_without_theme(env)
    end

    alias_method :call_without_theme, :call
    alias_method :call, :call_with_theme
  end
end
