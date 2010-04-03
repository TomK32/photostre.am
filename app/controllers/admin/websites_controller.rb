class Admin::WebsitesController < Admin::ApplicationController
  make_resourceful do
    actions :all
    belongs_to :current_user

    before :create do
      current_object.user_ids << current_user.id
    end

    before :edit, :update, :show do
      if ! @current_object.new_record? and ! @current_object.user_ids.include?(current_user.id)
        flash[:error] = t(:'admin.websites.access_denied')
        redirect_to :action => :index
      end
    end

    # combine params subdomain and domain to params[:website][:domain]
    before :create do
      if !(params[:subdomain].blank? or params[:domain].blank?) && params[:website][:domain].blank?
        if !Website.system.where(:domains => params[:domain]).empty?
          current_object.domains << params[:subdomain] + '.' + params[:domain]
        elsif !Website.system.where(:domains => params[:domain], :user_ids => current_user.id).empty?
          current_object.domains << params[:subdomain] + '.' + params[:domain]
        else
          flash[:error] = t(:'websites.create.domain_error')
        end
      end
    end

  end

  private
  def current_objects
    @current_objects ||= current_user.websites
  end
end
