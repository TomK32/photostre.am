class PhotosController < ApplicationController

  caches_action :show, :index

  make_resourceful do
    actions :show, :index
    belongs_to :album
  end

  private
  def current_objects
    return @current_objects if @current_objects
    if params[:album_id]
      scope = current_website.albums.find(params[:album_id]).photos
    else
      scope = current_website.photos
    end
    scope.published.paginate(:page => params[:page], :per_page => 10 )
  end

end
