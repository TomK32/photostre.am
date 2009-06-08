# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include Authentication

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '67063682bba404156fa25ca1e1f99060'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password

  private
  def current_website
    @current_website ||= Website.active.find_by_domain(request.host)
    if @current_website.nil?
      flash.now[:error] = 'There is no domain %s registered with us or not active.' % request.host
    end
    @current_website ||= Website.active.first
    @current_website
  end
  helper_method :current_website
  
  def current_identity
    @current_identity = Identity.find_by_id(session[:identity_id])
  end

  def authenticated?
    ! current_identity.nil?
  end
end
