class PagesController < ApplicationController

  inherit_resources
  actions :show, :index

  def show
    render 'static/404', :status => 404 and return if @page.nil?
    show!
  end

  private
  def resource
    @page = current_website.pages.where(:permalink => params[:id]).first
    @page ||= current_website.pages.find(params[:id])
  end

  def collection
    @pages ||= current_website.pages.published.roots
  end
end
