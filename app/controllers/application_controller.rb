# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include Authentication
  include ExceptionNotifiable
  before_filter :set_theme

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '67063682bba404156fa25ca1e1f99060'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  filter_parameter_logging :password

  protected
  def current_website
    return @current_website if @current_website
    @current_website ||= Website.active.find_by_domain(request.host)
    @current_website ||= Website.active.find_by_domain(request.host.sub(/^www\./, ''))
    @current_website ||= Website.active.find_by_domain('www.' + request.host)
    if @current_website.nil?
      flash.now[:error] = 'There is no domain %s registered with us or not active.' % request.host
    end
    @current_website ||= Website.system.first
    return @current_website
  end
  helper_method :current_website

  def set_theme
    return if current_website.nil?
    # use the websites theme for views
    self.prepend_view_path File.join(current_theme_path, 'views')
  end

  def current_theme_path
    File.join(RAILS_ROOT, 'themes', 'websites', current_website.domain, current_website.theme_path)
  end

  def current_album
    return if params[:album_id].nil?
    @current_album ||= current_website.albums.published.find_by_permalink!(params[:album_id])
    @current_album ||= current_website.albums.published.find(params[:album_id])
  end
  def current_identity
    @current_identity = Identity.find_by_id(session[:identity_id])
  end

  rescue_from ActiveRecord::RecordNotFound do
    render 'shared/404', :status => 404
  end
end
