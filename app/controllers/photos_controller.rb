class PhotosController < ApplicationController

  inherit_resources
  respond_to :html, :js
  actions :show, :index

  def index
    @photos = parent.related_photos.paginate(pagination_defaults)
  end

  private
  def resource
    @photo = parent.related_photos.where(:permalink => params[:id]).first
    raise Mongoid::Errors::DocumentNotFound.new(Photo, params[:id]) and return if @photo.nil?
    return @photo
  end
  def parent
    return @parent if @parent
    @parent_model = 'Website'
    @parent = current_website
    %w(Album Page).each do |klass|
      klass.downcase!
      if ! (@parent_id = params["#{klass}_id"]).blank?
        @parent_model = klass.pluralize
        @parent = current_website.send(@parent_model.to_sym).published.where(:permalink => @parent_id).first
        break
      end
    end
    @parent || current_website
  end
end
