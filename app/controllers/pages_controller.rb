class PagesController < ApplicationController

  inherit_resources
  actions :show, :index

  private
  def resource
    @page = current_website.pages.where(:permalink => params[:id]).first
  end

  def collection
    @pages ||= current_website.pages.published.roots
  end
end
