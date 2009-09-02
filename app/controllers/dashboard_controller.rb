class DashboardController < ApplicationController
  before_filter :authenticated
  def index
    @user = current_user
    @sources = @user.sources
    @photos = @user.photos.recent.all(:limit => 8)
    @websites = current_user.websites
  end
end
