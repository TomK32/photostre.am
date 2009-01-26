class SessionsController < ApplicationController
  # for OpenID
  skip_before_filter :verify_authenticity_token, :only => :create
  helper :users
  def create
    if using_open_id?
      open_id_authentication(params[:openid_identifier] || params[:openid_url])
    end
  end
  
  def delete
    session[:user_id] = nil
    @current_user = nil
    redirect_to '/' and return
  end
  
  protected
    def open_id_authentication(identity_url)
      authenticate_with_open_id(identity_url,
          :required => %w(nickname email),
          :optional => 'fullname') do |result, identity_url, registration|
        if result.successful?
          @identity = Identity.find_or_create_by_identity_url(identity_url)
          if @identity.user.nil?
            unless User.find_by_id(session[:user_id]).nil?
              @identity.user_id = session[:user_id]
              @identity.save
            else
              logger.debug("creating new user '%s'" % registration["nickname"])
              @user = User.new(:login => registration["nickname"],
                  :name => registration["fullname"], :email => registration["email"])
              unless @user.save
                # not enough data from the provider. e.g. missing email or nickname
                @identity.save
                session[:identity_id] = @identity.id
                render :template => 'users/new' and return
              end
              @identity.update_attribute :user_id, @user.id
            end
          end
          @current_user = @identity.user
          successful_login
        else
          failed_login result.message
        end
      end
    end
  
  
  private
    def successful_login
      session[:identity_id] = @identity.id
      session[:user_id] = @current_user.id
      redirect_to(root_url, :status=>302) and return
    end
  
    def failed_login(message)
      flash[:error] = message
      redirect_to(new_session_url)
    end
end
