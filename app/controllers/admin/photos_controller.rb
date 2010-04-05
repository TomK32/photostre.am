class Admin::PhotosController < Admin::ApplicationController

  inherit_resources
  actions :index, :show, :edit, :update, :delete
  def update
    update! do |format|
      format.js { render :json => {:success => true}}
      format.html { redirect_to object_path }
    end
  end
  def index
    if params[:webiste_id].nil?
      @websites = current_user.websites
    else
      @website = current_user.websites.find(params[:website_id])
      @albums = @website.albums
    end
    index!
  end

  def show
    show! do |format|
      format.html
      format.js { render :action => 'show', :layout => false }
    end
  end

  private
  def collection
    if ! params[:website_id].blank?
      @website ||= current_user.websites.where(:_id => params[:website_id]).first
      scope = @website.related_photos
    elsif ! params[:album_id].blank?
      @website ||= current_user.websites.where(:'albums.id' => params[:album_id]).first
      @album ||= @website.albums.where(:_id => params[:album_id]).first
      scope = @album.related_photos
      conditions ||= {:include => 'related_photos.photo'}
    else
      scope ||= Photo
      conditions = {:user_id => current_user.id}
    end

    if ! params[:search].blank?
      scope = scope.search(params[:search])
    end
    if ! params[:tags].blank?
      conditions = {:tags => params[:tags].split(/ ,/)}
    end
    params[:per_page] = 16 if params[:per_page].blank?
    @photos ||= scope.paginate(pagination_defaults(:conditions => conditions))
  end
end
