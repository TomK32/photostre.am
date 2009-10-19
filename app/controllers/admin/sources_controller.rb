class Admin::SourcesController < Admin::ApplicationController

  make_resourceful do
    actions :all

    after :create do
      current_object.user = current_user
    end

    before :edit, :update, :show do
      if ! @current_object.new_record? and @current_object.user != current_user
        flash[:error] = t(:'admin.sources.access_denied')
        redirect_to :action => :index
      end
    end
    before :show do
      @photos = current_object.photos.find(:all, :limit => 16, :order => 'created_at DESC')
    end
  end

  def create
    source_type = params[:source][:source_type]
    if source_type.blank? or ! Source::ACTIVE_TYPES.include?(source_type)
      @source = source_type.constantize.new({:website_id => current_website.id}.merge(params[:source]))
      send("create_" + source_type.demodulize.underscore)
    else
      @source = Source.new(params[:source])
      render :action => :new and return
    end
    @source.user = current_user
    if @source.save
      redirect_to source_url(@source)
    else
      flash[:error] = "Could not save the new source"
      render :action => :new and return
    end
  end

  def reauthenticate
    send("create_" + @source[:type].demodulize.underscore)
  end

  def authenticate_flickr_account
    hit = false
    current_user.sources.find(:all, :order => 'updated_at DESC').each do |source|
      if source.authenticate(params[:frob])
        redirect_to sources_url and return
      end
    end
    flash[:error] = "Can't verify your account with flickr. Please retry"
    redirect_to sources_url and return
  end
  

  private
  def create_flickr_account
    @source.token = nil
    if @source.save
      redirect_to @source.authentication_url and return
    end
  end
end
