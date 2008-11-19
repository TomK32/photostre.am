class AlbumsController < ApplicationController
  def index
    @albums = Album.published
  end
  
  def new
    @album = Album.new
  end
end
