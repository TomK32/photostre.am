module Rack
  # Allows you to overwrite the REQUEST_URL in the env so you can set a different
  # root_path for your Websites.
  class DomainDispatcher
    def initialize(app, options={}, &block)
      @app = app
    end
  
    def call(env)
      # Overwrite the REQUEST_URI by whatever the Website's root_path may be.
      if env['REQUEST_URI'] == '/'
        website = Website.find_by_domain(env['SERVER_NAME'])
        website ||= Website.find_by_domain(env['SERVER_NAME'].gsub(/^www\./, ''))
        env['REQUEST_URI'] = website.root_path
      end
      @app.call(env)
    end
  end
end