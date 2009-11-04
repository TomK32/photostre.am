class Admin::SourcesController < Admin::ApplicationController
  skip_before_filter :authenticated, :only => :create

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

  def create
    # It's enough if we authenticate against flickr, so create a user here
    if !logged_in?
      @current_user = User.new(:login => params[:source][:username])
      @current_user.save(false) # we don't have a mail address, yet
      self.current_user=(@current_user)
    end
    source_type = params[:source][:source_type]
    if source_type.blank? or ! Source::ACTIVE_TYPES.include?(source_type)
      @current_object = source_type.constantize.new({:website_id => current_website.id}.merge(params[:source]))
      send("build_" + source_type.demodulize.underscore)
    else
      @current_object = Source.new(params[:source])
      render :action => :new and return
    end
    current_object.user = current_user
    if current_object.save
      redirect_to object_url(current_object)
    else
      flash[:error] = "Could not save the new source"
      render :action => :new and return
    end
  end

  def reauthenticate
    send("build_" + current_object[:type].demodulize.underscore)
  end

  def authenticate_flickr_account
    hit = false
    current_user.sources.find(:all, :order => 'updated_at DESC').each do |source|
      if source.authenticate(params[:frob])
        redirect_to objects_url and return
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
