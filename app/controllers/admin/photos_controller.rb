class Admin::PhotosController < Admin::ApplicationController
  
  make_resourceful do
    actions :all
    before :update do
      %w(albums websites).each do |association|
        next if(params[:photo][association.to_sym].blank?)
        associations = params[:photo].delete(association.to_sym)
        deleted_association_ids = associations.reject{|key,value| value.to_i != 0 }.keys

        # TODO should be something like current_user.send(association)
        new_association_ids = associations.reject{|key,value| value.to_i == 0}.keys

        association_ids = current_object.send(association.singularize + '_ids')
        association_ids = association_ids - deleted_association_ids + new_association_ids
        logger.debug(association_ids)
        current_object.send(association.singularize + '_ids=', association_ids)
      end
    end
    response_for :update do |format|
      format.js { render :json => {:success => true}}
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
    if ! params[:website_id].blank?
      @website = current_user.websites.find(params[:website_id]).first
      scope = @website.related_photos
    elsif ! params[:album_id].blank?
      @website = current_user.websites.find(:'albums.id' => params[:album_id]).first
      @album = @website.albums.find(params[:album_id])
      scope = @album.related_photos
    else
      scope ||= Photo
      conditions = {:user_id => current_user.id}
    end

    if ! params[:search].blank?
      scope = scope.search(params[:search])
    end
    if ! params[:tags].blank?
      conditions = {:tags => params[:tags].split(/ ,/)}
    end
    params[:per_page] = 16 if params[:per_page].blank?
    @current_objects ||= scope.paginate(pagination_defaults(:conditions => conditions))
  end
end
