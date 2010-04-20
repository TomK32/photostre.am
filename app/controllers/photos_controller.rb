class PhotosController < ApplicationController

  inherit_resources
  actions :show, :index

  def show
    @photo = parent.related_photos.where(:permalink => params[:id]).first
    @photo ||=  parent.related_photos.where(:_id => params[:id]).first
    render 'static/404', :status => 404 and return if resource.nil?
    show!
  end

  def index
    @photos = parent.related_photos.paginate(pagination_defaults)
  end

  private
  def parent
    return @parent if @parent
    %w(Album Website Page).each do |klass|
      if ! params["#{klass.downcase}_id"].blank?
        @parent_model = klass
        # TODO status
        @parent = klass.constantize.find(params["#{klass.downcase}_id"])
      end
    end
    @parent || current_website
  end
end
