class Admin::PhotosController < Admin::ApplicationController

  respond_to :js, :html

  inherit_resources
  actions :index
  def index
    if params[:webiste_id].nil?
      @websites = current_user.websites
    else
      @website = current_user.websites.find(params[:website_id])
      @albums = @website.albums
    end

    index!
  end

  private
  def collection
    return @photos if @photos
    if ! params[:source_album_id].blank?
      @album ||= current_user.sources.collect{|s| s.albums.find(params[:source_album_id])}.first
      scope = current_user.photos.where(:remote_id => {'$in' => @album.remote_photo_ids})
      conditions ||= {:include => 'related_photos.photo'}
    else
      scope = current_user.photos
    end

    if ! params[:search].blank?
      term = Regexp.new(split_search_term(params[:search]), Regexp::IGNORECASE)
      scope = scope.where(:title => term)
    end
    if ! params[:tags].blank?
      scope = scope.where(:tags.in => params[:tags].split(' '))
    end
    params[:per_page] = 24 if params[:per_page].blank?
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
