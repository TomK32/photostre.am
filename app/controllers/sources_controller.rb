class SourcesController < ApplicationController
  before_filter :authenticated

  before_filter :current_source, :only => [:show, :reauthenticate]

  def index
    @sources = current_user.sources
  end

  def show
    if @source.nil?
      flash[:error] = "Source either does not exist or not belong to you"
      redirect_to :action => :index and return
    end
  end

  def new
    @source = Source.new
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
    current_user.sources.find(:all, :order => 'updated_at DESC').each do |source|
      unless source.authenticate(params[:frob])
        flash[:error] = "Can't find the account that this frob might belong to. Please retry"
      end
      redirect_to sources_url and return
    end
  end
  

  private
  def create_flickr_account
    if @source.save
      redirect_to @source.authentication_url and return
    end
  end
  def current_source
    @source = current_user.sources.find(params[:id])
  end
end
