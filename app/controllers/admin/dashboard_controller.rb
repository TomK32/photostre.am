class Admin::DashboardController < Admin::ApplicationController
  def index
    @user = current_user
    @sources = @user.sources
    @photos = @user.photos.recent.all(:limit => 16)
    @websites = current_user.websites
  end
end
