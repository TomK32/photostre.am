class UsersController < ApplicationController
  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      unless current_identity.nil?
        current_identity.update_attribute(:user_id, @user.id)
      end
      redirect_to '/' and return
    else
      flash.now[:error] = "Couldn't save your account"
      render :action => 'new' and return
    end
  end
end
