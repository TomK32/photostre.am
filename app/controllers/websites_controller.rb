class WebsitesController < ApplicationController
  before_filter :set_website, :only => [:edit, :update]

  def index
    @websites = current_user.websites
  end

  def new
    @website = current_user.websites.new(params[:website])
    @website.domain ||= [current_user.login.downcase, current_website.domain].join('.')
  end

  def edit
  end

  def create
    @website = Website.new(params[:website])
    if @website.save
      @website.users << current_user
      redirect_to :action => :index and return
    else
      flash[:error] = "Couldn't create website"
      render :new and return
    end
  end

  def update
    @website.attributes = params[:website]
    if @website.save
      redirect_to :action => :index and return
    else
      flash[:error] = "Couldn't save website"
      render :edit and return
    end
  end

  def set_website
    @website = Website.find(params[:id])
    if ! @website.users.include?(current_user)
      flash[:error] = "You are not allowed to edit this website"
      redirect_to :action => :index and return
    end
  end
end
