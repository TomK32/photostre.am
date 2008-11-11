class SourcesController < ApplicationController
  before_filter :authenticated

  def index
    @sources = current_user.sources
  end

  def new
    @source = Source.new
  end

  def create
    @source = current_user.sources.new(params[:source])
    if @source.save
      redirect_to source_url(@source)
    else
      flash[:error] = "Could not save the new source"
      render :action => :new and return
    end
  end
end
