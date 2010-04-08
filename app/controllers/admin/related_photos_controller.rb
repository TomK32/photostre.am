class Admin::RelatedPhotosController < Admin::ApplicationController
  inherit_resources
  belongs_to :website, :album
  before_filter :owner_required

  def create
    if ! photo = current_user.photos.find(params[:related_photo][:photo_id])
      flash[:error] = t(:'related_photos.not_allowed')
      redirect_to dashboard_path and return
    end
    parent.related_photos.build(params[:related_photo])
    parent.save!
    respond_to do |format|
      format.js { render :json => :success, :layout => false }
    end
  end

  private
  def parent
    return @parent if @parent
    if params[:website_id]
      @parent ||= @website = Website.find(params[:website_id])
    else
      @website Website.where(:"#{parent_}")
  end
  def owner_required
    website = parent.is_a?(Website) ? parent : parent.website
    if ! website.user_ids.include?(current_user.id)
      flash[:error] = t(:'related_photos.not_allowed')
      redirect_to dashboard_path and return
    end
  end
end
