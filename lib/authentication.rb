module Authentication
  def self.included(base)
    base.send(:helper_method, :current_user)
    base.send(:helper_method, :logged_in?)
  end

  private

  def authenticated
    unless logged_in?
      flash[:error] = "You must be logged in for this action"
      redirect_to login_url and return false
    end
    return true
  end

  def current_user
    return @current_user if @current_user
    return nil if session[:user_id].blank?
    @current_user ||= User.find(session[:user_id]) rescue nil
    session[:user_id] = nil if @current_user.nil?
    @current_user
  end

  def current_user=(user)
    if user.nil?
      session[:user_id] = @current_user = nil
    else
      @current_user = user
      session[:user_id] = user.id
    end
  end

  def logged_in?
    ! current_user.nil?
  end
end