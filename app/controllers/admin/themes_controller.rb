class Admin::ThemesController < Admin::ApplicationController
  make_resourceful do
    actions :all
  end
  
  def current_objects
    scope = Theme.paginate(pagination_defaults)
  end
end
