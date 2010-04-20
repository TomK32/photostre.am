class PhotosController < ApplicationController

  inherit_resources
  actions :show, :index

  def index
    @photos = parent.related_photos.paginate(pagination_defaults)
  end

  private
  def resource
    @photo = parent.related_photos.where(:permalink => params[:id]).first
  end
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
