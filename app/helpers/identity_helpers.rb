module IdentitiesHelper
  def current_identity
    @current_identity = Identity.find_by_id(session[:identity_id])
  end

  def authenticated?
    ! current_identity.nil?
  end
end
