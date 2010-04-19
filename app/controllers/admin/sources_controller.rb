class Admin::SourcesController < Admin::ApplicationController
  skip_before_filter :authenticated, :only => [:create, :authenticate_flickr_account]
  before_filter :owner_required, :only => [:edit, :update, :show]
  inherit_resources
  actions :all

  def show
    @photos = resource.photos.paginate(pagination_defaults)
    show!
  end

  def create
    source_type = params[:source][:source_type]
    if source_type.blank? or ! Source::ACTIVE_TYPES.include?(source_type)
      # Source already exists, use it to reauthenticate
      if(@resource = source_type.constantize.find_by_username(params[:source][:username]))
        send("build_" + source_type.demodulize.underscore)
        return
      end
      @resource = source_type.constantize.new(params[:source])
    else
      @resource = Source.new(params[:source])
      render :action => :new and return
    end

    # It's enough if we authenticate against flickr, so create a user here
    if !logged_in?
      @current_user = User.new(:login => params[:source][:username])
      begin
        @current_user.save(false) # we don't have a mail address, yet
        self.current_user=(@current_user)
      rescue ActiveRecord::StatementInvalid => ex
        logger.info('User tried to create a %s source with username %s but there is already such a user.' % [params[:source][:source_type], params[:source][:username]])
        flash[:notice] = t(:'admin.sources.create.error_on_creating_user')
      end
    end
    current_user.sources << @resource
    if @resource.save
      if ! resource.authenticated?
        send("build_" + source_type.demodulize.underscore)
      else
        redirect_to resource_path(resource)
      end
    else
      flash[:error] = t(:'admin.sources.create.error')
      render :action => :new and return
    end
  end

  def reauthenticate
    send("build_" + resource[:type].demodulize.underscore)
  end

  def authenticate_flickr_account
    if !logged_in?
      source = Source::FlickrAccount.new
      source.authenticate(params[:frob])
      user = User.where(:'sources.flickr_nsid' => source.flickr.auth.token.user_id).first

      # no user, create one
      if ! user
        source.username = source.flickr.auth.token.username
        source.flickr_nsid = source.flickr.auth.token.user_id
        source.token = source.flickr.auth.token.token
        source.is_pro = source.person.is_pro

        # no user, let's create one on the fly. super fly.
        user = User.new(:login => (source.username || source.flickr_nsid),
            :name => source.flickr.auth.token.user_real_name || source.username)
        user.sources << source
        source.save!
      end

      self.current_user=(user)
      redirect_to dashboard_path and return
    else
      # already logged in, let see if he already got that account authenticate
      source = Source::FlickrAccount.new
      source.authenticate(params[:frob])
      old_source = current_user.sources.where(:flickr_nsid => source.flickr.auth.token.user_id).first
      # this is reauthentication, update the token and you're find
      if old_source
        old_source.update_attributes(:token => source.flickr.auth.token.token)
      else
        # store the new one in the user
        user.sources << source
        source.update_attributes(:username => source.flickr.auth.token.username,
          :flickr_nsid => source.flickr.auth.token.user_id,
          :token => source.flickr.auth.token.token, :is_pro => source.flickr.person.is_pro)
        source.save!
        redirect_to dashboard_url and return
      end
      redirect_to collection_path and return
    end
    flash[:error] = "Can't verify your account with flickr. Please retry"
    redirect_to collection_path and return
  end

  private
  def owner_required
    if ! resource.new_record? and resource.user != current_user
      flash[:error] = t(:'admin.sources.access_denied')
      redirect_to :action => :index
    end
  end

  def resource
    @source ||= current_user.sources.find(params[:id])
  end

  def collection
    @sources ||= current_user.sources.find(:all)
  end

  def build_flickr_account
    resource.token = nil
    # All fine, take it straight to authenticate with flickr
    if resource.valid? and resource.save!
      redirect_to resource.authentication_url and return
    end
  end
end
