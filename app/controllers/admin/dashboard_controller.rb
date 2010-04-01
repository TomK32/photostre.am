class Admin::DashboardController < Admin::ApplicationController
  def index
    @user = current_user
    @photos = @user.photos.recent.limit(16)
    @websites = current_user.websites.all
  end
end
