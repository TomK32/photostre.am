class Admin::RelatedPhotosController < Admin::ApplicationController
  inherit_resources
  belongs_to :website, :album
  before_filter :owner_required

  def create
    if ! photo = current_user.photos.find(params[:related_photo][:photo_id])
      flash[:error] = t(:'related_photos.not_allowed')
      redirect_to dashboard_path and return
    end
    related_photo = parent.related_photos.build(params[:related_photo])
    related_photo.save!
    respond_to do |format|
      format.js { render :text => t(:'admin.photos.index.items', :count => parent.related_photos.count), :layout => false }
    end
  end

  private
  def parent
    return @parent if @parent
    if params[:website_id]
      @parent ||= @website = Website.find(params[:website_id])
    end
  end
  def owner_required
    website = parent.is_a?(Website) ? parent : parent.website
    if ! website.user_ids.include?(current_user.id)
      flash[:error] = t(:'related_photos.not_allowed')
      redirect_to dashboard_path and return
    end
  end
end
