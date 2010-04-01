class Admin::AlbumsController < Admin::ApplicationController
  make_resourceful do
    actions :all
    belongs_to :website
    def current_object
      @current_object ||= current_website.albums.find(params[:id])
    end

    def current_objects
      @current_objects ||= current_website.albums.find(:all,
        :order => "created_at DESC", :page => {:current => params[:page], :size => 10 } )
    end
    before :show do
      @photos = current_object.photos.paginate(pagination_defaults)
    end
    before :all do
      @website = current_user.website.find(params[:website_id]) if params[:website_id]
    end
  end
end
