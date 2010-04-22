class StaticController < ApplicationController
  before_filter :is_system
  def index
    @websites = Website.latest.active.limit( 5 )
    @albums = Album.latest.published.limit( 5)
  end
  def statistics
    redirect_to root_path unless logged_in? and current_user.login == 'TomK32'
    @users = User.order_by(['created_at', :desc]).paginate(pagination_defaults)
  end

  def is_system
    redirect_to photos_path and return unless current_website.system?
  end
end
