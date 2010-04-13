class SessionsController < ApplicationController
  def create
    redirect_to Source::FlickrAccount.new.authentication_url and return
  end

  def delete
    self.current_user=(nil)
    redirect_to (params[:return_to] || '/') and return
  end
end
