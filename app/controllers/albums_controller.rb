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
    scope = current_website.albums.published
    @current_objects[:per_page] ||= scope.paginate(:page => params[:page], :per_page => per_page)
    @current_objects[:per_page]
  end

  def current_object
    scope = current_website.albums.published
    @current_object ||= scope.find_by_permalink!(params[:id]) if params[:id]
    @current_object ||= scope.find(params[:id]) if params[:id]
    @current_object
  end
end
