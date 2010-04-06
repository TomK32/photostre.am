class Admin::ApplicationController < ApplicationController
  layout 'admin/application'
  before_filter :authenticated
  before_filter :update_sources

  private
  def authenticated?
    ! current_identity.nil?
  end

  def update_sources
    if logged_in?
      unless current_user.sources.active.where('last_updated_at IS NULL OR last_updated_at < "%s"' % (Time.now - 3.hours).to_s(:db)).collect(&:call_worker).empty?
        flash[:message] = t(:'admin.sources.updating')
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
end