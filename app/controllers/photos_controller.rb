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
      flash[:error] = t(:'photos.errors.edit_photo', :default => 'You cannot edit this photo')
      redirect_to photo_url(photo) and return
    end
  end
  
  private
  def current_photo
    begin
      @photo ||= Photo.find_by_permalink(params[:id])
      @photo ||= Photo.find(params[:id])
    rescue ActiveRecord::RecordNotFound => ex
      flash.now[:error] = t(:'photos.errors.photo_not_found')
      render :action => :index, :status => 404 and return
    end
    
    @meta_keywords = @photo.tag_list
    @page_title = @photo.title
  end
end
