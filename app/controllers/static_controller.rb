class StaticController < ApplicationController
  def index
    @websites = Website.latest.all(:limit => 5, :conditions => {:state => 'active'})
    @albums = Album.latest.published.all(:limit => 5)
  end
end
