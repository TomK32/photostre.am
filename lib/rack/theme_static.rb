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
        directory = website.theme_path if website.nil?
        directory ||= 'default'

        file_server = Rack::File.new(Rails.root.join('themes', directory, "public"))
        file_server.call(env)
      elsif @urls.any? { |url| path.index(url) == 0 }
        @file_server.call(env)
      else
        @app.call(env)
      end
    end
  end
end
