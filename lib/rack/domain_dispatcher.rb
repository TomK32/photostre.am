module Rack
  # Allows you to overwrite the REQUEST_URI in the env so you can set a different
  # root_path for your Websites.
  class DomainDispatcher
    def initialize(app, options={}, &block)
      @app = app
    end
  
    def call(env)
      # Overwrite the REQUEST_URI by whatever the Website's root_path may be.
      # For some reason apache and mongrel give a different REQUEST_URI
      path = env['REQUEST_PATH'] || env['PATH_INFO']
      if path == '/' || path.match(/^http:\/\/[^\/]*\/$/)
        website = Website.find_by_domain(env['SERVER_NAME'])
        website ||= Website.find_by_domain(env['SERVER_NAME'].gsub(/^www\./, ''))
        env['REQUEST_URI'][/\//] = website.root_path if website and !website.root_path.blank?
      end
      @app.call(env)
    end
  end
end

