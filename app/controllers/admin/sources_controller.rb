class Admin::SourcesController < Admin::ApplicationController
  skip_before_filter :authenticated, :only => [:create, :authenticate_flickr_account]

  make_resourceful do
    actions :all

    before :edit, :update, :show do
      if ! current_object.new_record? and current_object.user != current_user
        flash[:error] = t(:'admin.sources.access_denied')
        redirect_to :action => :index
      end
    end
    before :show do
      @photos = current_object.photos.find(:all, :limit => 16, :order => 'created_at DESC')
    end
  end

  def current_objects
    @current_objects ||= current_user.sources.find(:all)
  end

  def create
    source_type = params[:source][:source_type]
    if source_type.blank? or ! Source::ACTIVE_TYPES.include?(source_type)
      # Source already exists, use it to reauthenticate
      if(@current_object = source_type.constantize.find_by_username(params[:source][:username]))
        send("build_" + source_type.demodulize.underscore)
        return
      end
      @current_object = source_type.constantize.new(params[:source])
    else
      @current_object = Source.new(params[:source])
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
    current_object.user = current_user
    if current_object.save
      if ! current_object.authenticated?
        send("build_" + source_type.demodulize.underscore)
      else
        redirect_to object_url(current_object)
      end
    else
      flash[:error] = t(:'admin.sources.create.error')
      render :action => :new and return
    end
  end

  def reauthenticate
    send("build_" + current_object[:type].demodulize.underscore)
  end

  def authenticate_flickr_account
    if !logged_in?
      source = Source::FlickrAccount.new
      source.authenticate(params[:frob])
      @current_object = Source::FlickrAccount.find_by_flickr_nsid(source.flickr.auth.token.user_id)

      # valid source, log the user in, all fine
      if @current_object
        self.current_user=(@current_object.user)
        redirect_to dashboard_path and return
      end
      source.username = source.flickr.auth.token.username
      source.flickr_nsid = source.flickr.auth.token.user_id
      source.token = source.flickr.auth.token.token
      @current_object = source

      @user = User.new(:login => source.flickr.auth.token.user_id, :name => source.flickr.auth.token.user_real_name || source.flickr.auth.token.username)
      @user.save(false) # we don't have an email yet
      @current_object.user = @user
      if @current_object.save!
        # last is to authenticate the newly created source
        @current_object.authenticate(params[:frob])
        self.current_user=(@user)
        redirect_to dashboard_path and return
      else
        render :action => 'new' and return
      end
    else
      # logged in, obviously clicked the reauth link
      # loop over all sources available. no better solution, sorry
      current_user.sources.find(:all, :order => 'updated_at DESC').each do |source|
        if source.authenticate(params[:frob])
          redirect_to objects_url and return
        end
      end
    end
    flash[:error] = "Can't verify your account with flickr. Please retry"
    redirect_to objects_url and return
  end

  private
  def build_flickr_account
    current_object.token = nil
    # All fine, take it straight to authenticate with flickr
    if current_object.valid? and current_object.save!
      redirect_to current_object.authentication_url and return
    end
  end
end
