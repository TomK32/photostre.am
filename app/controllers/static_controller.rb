class StaticController < ApplicationController
  def index
    @websites = Website.active.latest.all(:limit => 5)
    @albums = Album.latest.published.all(:limit => 5)
  end
end
