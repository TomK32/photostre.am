class DashboardController < ApplicationController
  before_filter :authenticated
  def index
    @user = current_user
  end
end
