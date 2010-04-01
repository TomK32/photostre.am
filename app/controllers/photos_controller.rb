class PhotosController < ApplicationController

  #caches_action :show, :index

  make_resourceful do
    actions :show, :index
    belongs_to :album, :website
  end

  private
  def current_objects
    return @current_objects unless @current_objects.nil?
    if current_album
      scope = current_album.photos
    else
      scope = current_website.photos
    end
    @current_objects = scope.paginate(pagination_defaults)
  end

  def current_object
    return false if params[:id].blank?
    @current_object = current_model.published.find_by_permalink(params[:id]) ||
                      current_model.published.find(params[:id])
  end
  def parent_object
    if params[:album_id]
      @parent_object ||= current_album
    end
    @parent_object ||= parent_model.nil? ? nil : parent_model.find(params["#{parent_name}_id"])
    @parent_object
  end
end
