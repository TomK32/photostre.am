class PagesController < ApplicationController

  inherit_resources
  actions :show, :index

  private
  def resource
    @page = current_website.pages.where(:permalink => params[:id]).first
    raise Mongoid::Errors::DocumentNotFound.new(Page, params[:id]) and return if @page.nil?
    @page
  end

  def collection
    @pages ||= current_website.pages.published.roots
  end
end
