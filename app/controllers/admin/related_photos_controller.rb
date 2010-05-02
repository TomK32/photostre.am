class Admin::RelatedPhotosController < Admin::ApplicationController
  before_filter :owner_required
  inherit_resources
  actions :index, :show
  belongs_to :website, :album
  respond_to :js, :html

  def create
    if ! photo = current_user.photos.find(params[:related_photo][:photo_id])
      flash[:error] = t(:'related_photos.not_allowed')
      redirect_to dashboard_path and return
    end
    related_photo = RelatedPhoto.new(params[:related_photo])
    parent.related_photos << related_photo
    related_photo.save!
    respond_to do |format|
      format.js { render :text => t(:'admin.photos.index.items', :count => parent.related_photos.count), :layout => false and return }
    end
  end

  private
  def parent
    return @parent if @parent
    if params[:website_id]
      @parent ||= @website = Website.find(params[:website_id])
    elsif params[:album_id]
      @website = Website.where('albums._id' => params[:album_id]).first
      @parent = @website.albums.find(params[:album_id])
    elsif params[:page_id]
      @website = Website.where('pages._id' => params[:page_id]).first
      @parent = @website.pages.find(params[:page_id])
    end
    return @parent
  end
  def owner_required
    website = parent.is_a?(Website) ? parent : parent.website
    if ! website.user_ids.include?(current_user.id)
      render(:text => t(:'admin.not_owner'), :success => false) and return
    end
  end
end
