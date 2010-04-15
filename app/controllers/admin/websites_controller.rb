class Admin::WebsitesController < Admin::ApplicationController
  inherit_resources
  actions :all

  before_filter :owner_required, :except => [:create, :new, :index]
  def create
    resource = build_resource

    resource.user_ids << current_user.id

    # TODO rewrite to allow multiple domains
    # combine params subdomain and domain to params[:website][:domain]
    if !(params[:subdomain].blank? or params[:domain].blank?) && params[:website][:domain].blank?
      if !Website.system.where(:domains => params[:domain]).empty?
        resource.domains << params[:subdomain] + '.' + params[:domain]
      elsif !Website.where(:domains => params[:domain], :user_ids => current_user.id).empty?
        resource.domains << params[:subdomain] + '.' + params[:domain]
      else
        flash[:error] = t(:'websites.create.domain_error')
      end
    end

    create!
  end

  private
  def collection
    @collection ||= current_user.websites
  end
end
