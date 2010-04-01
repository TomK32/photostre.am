class AlbumsController < ApplicationController
  make_resourceful do
    actions :all
    before :show do
      return if current_object.nil?
      @photos = current_object.photos.published.paginate(pagination_defaults)
    end
  end
  def current_objects(per_page = 5)
    scope = current_website.albums.published
    @current_objects ||= scope.paginate(pagination_defaults)
  end

  def current_object
    return false if params[:id].blank?
    scope = current_website.albums.published
    @current_object ||= scope.find_by_permalink!(params[:id])
    @current_object ||= scope.find(params[:id])
    @current_object
  end
end
