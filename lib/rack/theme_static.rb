require 'rack/utils'

module Rack
  class ThemeStatic < Rails::Rack::Static

    def call_with_theme(env)
      path = (env['REQUEST_PATH'] || env['PATH_INFO']).chomp()
      puts path
      if(path =~ /^\/themes\/.*?\/screenshot.png/)
        @file_server = ::Rack::File.new(::File.join(Rails.root, 'themes'))
        puts @file_server.inspect
      end
      if(path =~ /^\/(javascript|images|stylesheets)/)
        website = Website.find_by_domain(env['SERVER_NAME'])
        website ||= Website.find_by_domain(env['SERVER_NAME'].gsub(/^www\./, ''))
        if website
          @file_server = ::Rack::File.new(::File.join(Rails.root, 'themes', 'websites', website.domain, website.theme_path, "public"))
        end
      end
      call_without_theme(env)
    end
    alias_method_chain :call, :theme
  end
end
