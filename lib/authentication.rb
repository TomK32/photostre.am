module Authentication
  def self.included(base)
    base.send(:helper_method, :current_user)
    base.send(:helper_method, :logged_in?)
  end

  def authenticated
    unless logged_in?
      flash[:error] = "You must be logged in for this action"
      redirect_to login_url and return false
    end
    return true
  end

  def current_user
    @current_user = User.find_by_id(session[:user_id])
  end
  
  def logged_in?
    ! current_user.nil?
  end
end