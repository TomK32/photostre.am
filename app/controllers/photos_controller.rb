class PhotosController < ApplicationController
  
  before_filter :current_photo, :only => :show

  def index
    @photos = Photo.published.paginate(:limit => params[:limit], :page => params[:page])
  end
  
  def show
  end
  
  private
  def current_photo
    @photo ||= Photo.find(params[:id])
  end
end
