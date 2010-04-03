class Admin::RelatedPhotosController < Admin::ApplicationController

  make_resourceful do
    actions :create, :destroy
    belongs_to :website, :album

    before :create do
      current_object.photo = current_user.photos.find(params[:photo_id])
      website = parent_object.is_a?(Website) ? parent_object : parent_object.website
      if ! website.user_ids.include?(current_user.id)
        flash[:error] = t(:'related_photos.not_allowed')
        redirect_to dashboard_path and return
      end
    end
    # TODO check ownership on 
  end
end
