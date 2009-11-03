class Admin::WebsitesController < Admin::ApplicationController
  make_resourceful do
    actions :all
    belongs_to :current_user

    after :create do
      current_object.users << current_user
    end

    before :edit, :update, :show do
      if ! @current_object.new_record? and ! @current_object.users.include?(current_user)
        flash[:error] = t(:'admin.website.access_denied')
        redirect_to :action => :index
      end
    end

    # combine params subdomain and domain to params[:website][:domain]
    before :create do
      unless params[:subdomain].blank? && params[:domain].blank?
        if Website.system.find_by_domain(params[:domain])
          current_object.domain = params[:subdomain] + '.' + params[:domain]
        elsif current_user.websites.find_by_domain(params[:domain])
          current_object.domain = params[:subdomain] + '.' + params[:domain]
        end
      end
    end
  end

  def current_objects
    @current_objects ||= current_user.websites.find(:all)
  end
end
