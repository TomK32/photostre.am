class Admin::ThemesController < Admin::ApplicationController
  inherit_resources
  actions :all

  
  def create
    resource = build_resource
    resource.author ||= current_user
    create!
  end
end
