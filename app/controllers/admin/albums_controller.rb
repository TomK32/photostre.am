class Admin::AlbumsController < Admin::ApplicationController
  make_resourceful do
    actions :all
    belongs_to :website
    before :show do
      @photos = current_object.photos.paginate(pagination_defaults)
    end
    before :all do
      @website = current_user.website.find(params[:website_id]) if params[:website_id]
    end
  end

  private
  def current_object
    @current_object ||= parent_object.albums.find(params[:id])
  end

  def current_objects
    @current_objects ||= parent_object.albums.find(:all,
      :order => "created_at DESC", :page => {:current => params[:page], :size => 10 } )
  end
  def build_object
    @current_object ||= parent_object.albums.build
  end
end
