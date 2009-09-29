class Admin::PagesController < Admin::ApplicationController
  make_resourceful do
    actions :all
    belongs_to :website
    before :new, :create, :update do
      unless @website = current_user.websites.find(params[:website_id])
        flash[:error] = t(:'admin.pages.website.access_denied')
        redirect_to dashboard_path
      end
      current_object.user = current_user
    end
  end
end
