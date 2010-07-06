class StaticController < ApplicationController
  before_filter :is_system
  def index
    @websites = Website.where(:screenshot_filename.ne => nil).limit(6)
  end

  def is_system
    redirect_to photos_path and return unless current_website.system?
  end
end
