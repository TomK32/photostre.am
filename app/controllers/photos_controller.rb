class PhotosController < ApplicationController
  
  before_filter :current_photo, :only => [:show, :edit]
  caches_action :show, :index

  def index
    @photos = Photo.published.paginate(:limit => params[:limit], :page => params[:page])
  end
  
  def show
  end
  
  def edit
    if @photo.user_id != current_user.id
      flash[:error] = "You cannot edit this photo"
      redirect_to photo_url(photo) and return
    end
  end
  
  private
  def current_photo
    @photo ||= Photo.find(params[:id])
  end
end
