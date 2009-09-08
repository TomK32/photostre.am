class Admin::WebsitesController < Admin::ApplicationController
  make_resourceful do
    actions :all
    belongs_to :current_user

    after :create do
      current_object.users << current_user
    end

    before :edit, :update, :show do
      if ! @current_object.new_record? and ! @current_object.users.include?(current_user)
        flash[:error] = "You are not allowed to edit this website"
        redirect_to :action => :index
      end
    end
  end
    
  def current_objects
    @current_objects ||= current_user.websites.find(:all)
  end
end
