class AlbumsController < ApplicationController

  inherit_resources
  actions :show, :index

  def show
    @photos = resource.photos.published.paginate(pagination_defaults)
    show!
  end

  private
  def collection
    return @albums if @albums
    @albums ||= current_website.albums.published.paginate(pagination_defaults)
  end

  def resource
    return @album if @album
    @album = current_website.albums.published.where(:permalink => params[:id]).first
    raise Mongoid::Errors::DocumentNotFound.new(Album, params[:id]) and return if @album.nil?
    @album
  end
end
