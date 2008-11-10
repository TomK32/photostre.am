class PhotosController < ApplicationController
  def index
    @photos = Photo.active.paginate(:limit => params[:limit], :page => params[:page])
  end
end
