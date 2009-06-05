class StaticController < ApplicationController
  def index
    @websites = Website.latest.public
    @albums = Album.latest.public
  end
end
