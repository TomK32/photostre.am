class Admin::ThemesController < Admin::ApplicationController
  make_resourceful do
    actions :all
  end
  
  def current_objects
    scope = Theme.paginate(:per_page => params[:per_page], :page => params[:page])
  end
end
