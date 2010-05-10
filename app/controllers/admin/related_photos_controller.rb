class Admin::RelatedPhotosController < Admin::ApplicationController
  before_filter :owner_required
  inherit_resources
  actions :index, :show, :update
  respond_to :js

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

  def update
    update! do
      redirect_to resource_path(:format => params[:format]) and return
    end
  end

  def destroy
    @related_photo = parent.related_photos.where(:_id => params[:id]).first
    parent.related_photos.where(:_id => params[:id]).first.destroy
  end

  protected
  def parent
    if params[:album_id]
      return website.albums.find(params[:album_id])
    elsif params[:page_id]
      return website.pages.find(params[:page_id])
    else
      return website
    end
  end

  def owner_required
    if website.nil? || ! website.user_ids.include?(current_user.id)
      render(:text => t(:'admin.not_owner')) and return
    end
  end

  def begin_of_association_chain
    parent
  end
  def collection
    @related_photos ||= end_of_association_chain.paginate(pagination_defaults)
  end
  def resource
    @related_photo ||= end_of_association_chain.find(params[:id])
  end

  def website
    return @website if @website
    if params[:album_id]
      @website ||= Website.where('albums._id' => params[:album_id]).first
    elsif params[:page_id]
      @website ||= Website.where('pages._id' => params[:page_id]).first
    elsif params[:website_id]
      @website ||= current_user.websites.find(params[:website_id]).first
    end
    @website
  end
end
