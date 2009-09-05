class PhotosController < ApplicationController
  
  make_resourceful do
    actions :all
    belongs_to :current_user
    
  end
  
  private
  def current_objects
    @current_object ||= current_model.published.paginate(:page => params[:page], :per_page => 10 )
  end

  caches_action :show, :index

end
