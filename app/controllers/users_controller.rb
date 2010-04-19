class UsersController < ApplicationController
  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_url and return
    else
      flash.now[:error] = "Couldn't save your account"
      render :action => 'new' and return
    end
  end
end
