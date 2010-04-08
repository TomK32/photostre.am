require 'rack/utils'

module Rack
  class ThemeStatic < Rack::Static
    def call(env)
      path = env['PATH_INFO']

      if(path =~ /^\/(javascript|images|stylesheets)/)
        h = env['SERVER_NAME']
        website = nil
        [h, h.gsub(/^www\./, ''), 'www.' + h].uniq.each do |host|
          website ||= Website.active_or_system.where(:domains => host).first
        end
        directory = website.nil? ? 'default' : website.theme.directory
        file_server = ::Rack::File.new(::File.join(Rails.root, 'themes', directory, "public"))
        file_server.call(env)
      elsif @urls.any? { |url| path.index(url) == 0 }
        @file_server.call(env)
      else
        @app.call(env)
      end
    end
  end
end
