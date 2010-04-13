class AlbumsController < ApplicationController
  inherit_resources
  actions :all
  def show
    render '404' if current_object.nil?
    @photos = current_object.photos.published.paginate(pagination_defaults)
    show!
  end

  private
  def collection
    return @collection if @collection
    scope = current_website.albums.published
    @collection ||= scope.paginate(pagination_defaults)
  end

  def resource
    return @resource if @resource
    return false if params[:id].blank?
    scope = current_website.albums.published
    @resource ||= scope.find_by_permalink!(params[:id])
    @resource ||= scope.find(params[:id])
    @resource
  end
end
