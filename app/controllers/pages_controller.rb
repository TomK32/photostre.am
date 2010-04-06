class PagesController < ApplicationController

  def show
    @page = current_website.pages.where(:permalink => params[:id]).first
    @page ||= current_website.pages.find(params[:id])
  end

  def index
    @pages ||= current_website.pages.published.roots
  end
end
