class AlbumsController < ApplicationController

  inherit_resources
  actions :show, :index

  def show
    render 'static/404', :status => 404 and return if resource.nil?
    @photos = resource.photos.published.paginate(pagination_defaults)
    show!
  end

  private
  def collection
    return @collection if @collection
    @collection ||= current_website.albums.published.paginate(pagination_defaults)
  end

  def resource
    return @resource if @resource
    return false if params[:id].blank?
    @resource ||= current_website.albums.published.where(:permalink => params[:id]).first
  end
end
