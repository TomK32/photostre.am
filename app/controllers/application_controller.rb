# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'authentication'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include Authentication
  before_filter :set_theme, :set_locale
  before_filter :domain_not_found
  helper_method :parent


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '67063682bba404156fa25ca1e1f99060'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  protected

  rescue_from Mongoid::Errors::DocumentNotFound do |exception|
    render 'static/404', :status => 404
    return
  end


  def pagination_defaults(args = {})
    {:page => params[:page] || 1, :per_page => params[:per_page] || 20}.merge(args)
  end

  def current_website
    return @current_website if @current_website
    [request.host, request.host.sub(/^www\./, ''), 'www.' + request.host].uniq.each do |host|
      @current_website ||= Website.active_or_system.where(:domains => host).first
    end
    if @current_website.nil?
      @current_website = Website.where(:status => 'system').first
      @domain_not_found = true
    end
    return @current_website
  end
  helper_method :current_website

  def domain_not_found
    render 'static/domain_not_found', :status => '404' and return if @domain_not_found
  end

  def set_theme
    # use the websites theme to look for additional views templates
    self.prepend_view_path File.join(current_theme_path, 'app', 'views')
  end

  def current_theme_path
    @current_theme_path ||= Rails.root.join('themes', current_website.theme_path)
    config.assets_dir = @current_theme_path.join('public')
    @current_theme_path
  end
  helper_method :current_theme_path

  def current_album
    return if params[:album_id].nil?
    @current_album ||= current_website.albums.published.find_by_permalink!(params[:album_id])
    @current_album ||= current_website.albums.published.find(params[:album_id])
  end
  def current_identity
    @current_identity = Identity.find_by_id(session[:identity_id])
  end

#  rescue_from Mongoid::DocumentNotFound do
#    render 'shared/404', :status => 404
#  end
  def set_locale
    user_language = params[:language] || session[:language] || extract_locale_from_accept_language_header
    user_language = 'en' unless %w(en sv).include?(user_language)
    I18n.locale = user_language
    session[:language] = user_language
  end
  def current_language
    I18n.locale.to_sym
  end
  helper_method :current_language

  def extract_locale_from_accept_language_header
    languages = request.env['HTTP_ACCEPT_LANGUAGE'] || ENV['HTTP_ACCEPT_LANGUAGE']
    languages.scan(/^[a-z]{2}/).first unless languages.blank?
  end
end
