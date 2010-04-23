class Admin::PhotosController < Admin::ApplicationController

  inherit_resources
  actions :index, :show, :edit, :update, :delete
  def update
    update! do |format|
      format.js { render :json => {:success => true}}
      format.html { redirect_to resource_path }
    end
  end
  def index
    if params[:webiste_id].nil?
      @websites = current_user.websites
    else
      @website = current_user.websites.find(params[:website_id])
      @albums = @website.albums
    end
    index!
  end

  def show
    show! do |format|
      format.html
      format.js { render :action => 'show', :layout => false }
    end
  end

  private
  def collection
    return @photos if @photos
    if ! params[:website_id].blank?
      @website ||= current_user.websites.where(:_id => params[:website_id]).first
      scope = @website.related_photos
    elsif ! params[:album_id].blank?
      @website ||= current_user.websites.where(:'albums.id' => params[:album_id]).first
      @album ||= @website.albums.where(:_id => params[:album_id]).first
      scope = @album.related_photos
      conditions ||= {:include => 'related_photos.photo'}
    else
      scope ||= current_user.photos
    end

    if ! params[:search].blank?
      term = Regexp.new(split_search_term(params[:search]), Regexp::IGNORECASE)
      scope = scope.where(:title => term)
    end
    if ! params[:tags].blank?
      scope = scope.where(:tags.all => params[:tags].split(' '))
    end
    params[:per_page] = 16 if params[:per_page].blank?
    @photos ||= scope.order_by(['created_at', :desc]).paginate(pagination_defaults(:conditions => conditions))
  end

  private
  def split_search_term(term)
    term = term.split(' ')
    if term.size > 1
      term = '(' + term.join('|') + ')'
    end
    return term.to_s
  end
end
