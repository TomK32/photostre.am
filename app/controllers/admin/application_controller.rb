class Admin::ApplicationController < ApplicationController
  layout 'admin/application'
  before_filter :require_system_website
  before_filter :authenticated
  before_filter :update_sources

  private
  def authenticated?
    ! current_identity.nil?
  end

  def update_sources
    if logged_in?
      unless current_user.sources.active.excludes(:last_updated_at.gt => Time.now - 3.hours).collect(&:call_worker).empty?
        flash[:notice] = t(:'admin.sources.updating')
      end
    end
  end

  def owner_required(object = nil)
    object ||= resource
    if !object.new_record?
      if (object.respond_to?(:user) and object.user != current_user) ||
          (object.respond_to?(:user_ids) and ! object.user_ids.include?(current_user.id))
        flash[:error] = t(:'admin.not_owner')
        redirect_to :action => :index
      end
    end
  end

  def require_system_website
    if ! current_website.system?
      redirect_to root_path and return
    end
  end
end