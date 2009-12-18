class StaticController < ApplicationController
  def index
    @websites = Website.latest.all(:limit => 5, :conditions => {:state => 'active'})
    @albums = Album.latest.published.all(:limit => 5)
  end
  def statistics
    redirect_to root_path unless logged_in? and current_user.login == 'TomK32'
  end
end
