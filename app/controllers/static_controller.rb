class StaticController < ApplicationController
  before_filter :is_system
  def index
    @websites = Website.latest.active.limit( 5 )
    @albums = Album.latest.published.all(:limit => 5)
  end
  def statistics
    redirect_to root_path unless logged_in? and current_user.login == 'TomK32'
  end

  def is_system
    redirect_to photos_path and return unless current_website.system?
  end
end
