class Admin::ApplicationController < ApplicationController
  layout 'admin/application'
  before_filter :authenticated
  before_filter :update_sources

  def authenticated?
    ! current_identity.nil?
  end

  def update_sources
    if logged_in?
      unless current_user.sources.active.find(:all, :conditions => 'last_updated_at IS NULL OR last_updated_at < "%s"' % (Time.now - 3.hours).to_s(:db)).collect(&:call_worker).empty?
        flash[:message] = t(:'admin.sources.updating')
      end
    end
  end
end