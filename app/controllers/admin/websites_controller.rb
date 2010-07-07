class Admin::WebsitesController < Admin::ApplicationController
  inherit_resources
  actions :all
  before_filter :owner_required, :except => [:create, :new, :index]
  before_filter :process_source_ids, :only => [:create, :update]

  def create
    resource = build_resource
    process_remote_albums
    resource.user_ids << current_user.id
    if !(params[:subdomain].blank? or params[:domain].blank?) && params[:website][:domain].blank?
      if !Website.system.where(:domains => params[:domain]).empty?
        resource.domains << params[:subdomain] + '.' + params[:domain]
      elsif !Website.where(:domains => params[:domain], :user_ids => current_user.id).empty?
        resource.domains << params[:subdomain] + '.' + params[:domain]
      else
        flash[:error] = t(:'websites.create.domain_error')
      end
    end

    create! {
      redirect_to admin_photos_path and return
    }
  end

  def update
    process_remote_albums
    update!
  end

  private
  def collection
    @collection ||= current_user.websites
  end

  def process_source_ids
    params[:website][:source_ids] ||= []
    params[:website][:source_ids] = params[:website][:source_ids].collect{|k,v| k if v == '1' }.uniq.compact
  end

  def process_remote_albums
    return if params[:remote_albums].blank?
    params[:remote_albums].each do |source_id, remote_albums|
      remote_albums.each do |remote_id, value|
        album = resource.albums.where(:remote_id => remote_id).first
        if album.nil?
          remote_album = current_user.sources.find(source_id).albums.find(remote_id)
          album = Album.new(:title => remote_album.title, :description => remote_album.description, :remote_id => remote_album.id)
          resource.albums << album
          album.save
          Navvy::Job.enqueue(SourceWorker, :update_data, {:id => self.id})
        end
      end
    end
  end
end
