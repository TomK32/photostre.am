class Admin::ThemesController < Admin::ApplicationController
  make_resourceful do
    actions :all
    before :create do
      current_object.author ||= current_user
    end
  end
  
  def current_objects
    scope = Theme.paginate(pagination_defaults)
  end
end
