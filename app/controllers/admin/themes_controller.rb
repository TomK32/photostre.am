class Admin::ThemesController < Admin::ApplicationController
  inherit_resources
  actions :all
  skip_before_filter :authenticated, :only => :index

  def index
    index! {
      render :layout => 'application' and return
    }
  end
  def create
    resource = build_resource
    resource.author ||= current_user
    create!
  end

  private
  def collection
    @themes ||= Theme.public.paginate(pagination_defaults)
  end
end
