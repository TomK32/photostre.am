class Admin::MaintenanceController < Admin::ApplicationController
  before_filter :require_admin
  def index

  end
  def delete_jobs
    Navvy::Job.delete_all
    redirect_to :action => :index
  end
  def reset_sources
    User.collection.update({'sources.status' => "updating"}, {'$set' => {'sources.$.status' => 'active'}}, :multi => true)
    redirect_to :action => :index
  end

  private
  def require_admin
    redirect_to dashboard_path unless current_user.is_admin?
  end
end