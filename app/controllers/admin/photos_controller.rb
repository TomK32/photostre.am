class Admin::PhotosController < Admin::ApplicationController
  
  make_resourceful do
    actions :all
    before :update do
      websites = params[:photo].delete(:websites)
      current_object.websites.delete(Website.find(websites.collect{|key,value| key if value == '0' }.compact))
      websites.reject!{|key,value| value.to_i != 1}
      current_object.websites = current_user.websites.find(websites.keys)
    end
    response_for :update do |format|
      format.js {render :partial => 'photo', :object => current_object }
      format.html { redirect_to object_path}
    end
    before :index do
      if params[:webiste_id].nil?
        @websites = current_user.websites
      else
        @website = current_user.websites.find(params[:website_id])
        @albums = @website.albums
      end
    end
  end
  
  def current_objects
    @current_objects ||= current_model.paginate(:page => params[:page], :per_page => params[:per_page], :include => [:websites])
  end
end
