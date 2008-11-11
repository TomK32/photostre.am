class SourcesController < ApplicationController
  before_filter :authenticated

  def index
    @sources = current_user.sources
  end
  def new
    @source = Source.new
  end
end
