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
      path = env['PATH_INFO']
      if path == '/'
        h = env['SERVER_NAME']
        website = nil
        [h, h.gsub(/^www\./, ''), 'www.' + h].uniq.each do |host|
          website ||= Website.active_or_system.where(:domains => host).first
        end
        if website
          env['PATH_INFO'] = website.root_path if !website.root_path.blank?
        end
      end
      @app.call(env)
    end
  end
end

