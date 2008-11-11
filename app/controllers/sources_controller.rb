class SourcesController < ApplicationController
  before_filter :authenticated

  def index
    @sources = current_user.sources
  end

  def new
    @source = Source.new
  end

  def create
    source_type = params[:source][:source_type]
    if source_type.blank? or ! Source::ACTIVE_TYPES.include?(source_type)
      @source = source_type.constantize.new({:website_id => current_website.id}.merge(params[:source]))
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
end
