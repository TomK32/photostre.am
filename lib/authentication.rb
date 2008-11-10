module Authentication
  def authenticated
    if (session[:user_id].blank? or User.find_by_id(session[:user_id]).nil?)
      flash[:error] = "You must be logged in for this action"
      redirect_to login_url and return false
    end
    return true
  end
end