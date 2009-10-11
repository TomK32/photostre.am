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
      format.js { render :partial => 'photo', :object => current_object }
      format.html { redirect_to object_path }
    end
    before :index do
      if params[:webiste_id].nil?
        @websites = current_user.websites
      else
        @website = current_user.websites.find(params[:website_id])
        @albums = @website.albums
      end
    end
    response_for :show do |format|
      format.html
      format.js { render :action => 'show', :layout => false }
    end
  end
  
  def current_objects
    scope = current_user.photos
    if ! params[:search].blank?
      scope = scope.search(params[:search])
    end
    if ! params[:tags].blank?
      scope = scope.tagged_with(params[:tags], :on => :tags, :match_all => true)
    end
    params[:per_page] = 10 if params[:per_page].blank?
    @current_objects ||= scope.paginate(:page => params[:page], :per_page => params[:per_page])
  end
end
