class PagesController < ApplicationController
  caches_action :show, :index

  make_resourceful do
    actions :index, :show
    belongs_to :website
  end

  def current_object
    return false if params[:id].blank?
    @current_object ||= current_website.pages.published.find_by_permalink(params[:id])
    @current_object ||= current_website.pages.published.find(params[:id])
  end
  def current_objects
    @current_objects ||= current_website.pages.published.roots
  end
end
