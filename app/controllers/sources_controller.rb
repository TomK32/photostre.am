class SourcesController < ApplicationController
  before_filter :authenticated

  def index
    @sources = current_user.sources
  end

  def show
    @source = current_user.sources.find_by_id(params[:id])
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


  def authenticate_flickr_account
    # as one user can have multiple flickr accounts and we respect this,
    # we have to walk through all of them :(
    current_user.sources.find(:all, :order => 'updated_at DESC').each do |source|
      return true if source.authenticate(params[:frob])
    end
  end
  

  private
  def create_flickr_account
    if @source.save
      redirect_to @source.authentication_url and return
    end
  end
end
