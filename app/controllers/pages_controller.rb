class PagesController < ApplicationController

  inherit_resources
  actions :show, :index

  def show
    render 'static/404', :status => 404 and return if resource.nil?
    show!
  end

  private
  def resource
    @page = current_website.pages.where(:permalink => params[:id]).first
  end

  def collection
    @pages ||= current_website.pages.published.roots
  end
end
