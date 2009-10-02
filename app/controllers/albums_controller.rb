class AlbumsController < ApplicationController
  make_resourceful do
    actions :all
    after :show do
      return unless current_object
      @photos = current_object.photos.published.paginate(:page => params[:page], :per_page => params[:per_page])
    end
  end
  def current_objects(per_page = 5)
    per_page ||= params[:per_page]
    @current_objects ||= {}
    @current_objects[:per_page] ||= current_website.albums.published.paginate(:page => params[:page], :per_page => per_page)
    @current_objects[:per_page]
  end
  def current_object
    @current_object ||= current_website.albums.published.find_by_permalink!(params[:id])
    @current_object ||= current_website.albums.published.find(params[:id])
    @current_object
  end
end
