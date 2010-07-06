class Admin::MaintenanceController < Admin::ApplicationController
  before_filter :require_admin
  skip_before_filter :update_sources
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
  def update_active_sources
    User.only(:sources).all.map{|u| u.sources.map(&:call_worker)}
    redirect_to :action => :index
  end

  def statistics
  end
  def websites
    @websites = Website.order_by([:created_at, :desc]).paginate(pagination_defaults)
  end
  def users
    @users = User.order_by([:created_at, :desc]).paginate(pagination_defaults)
  end
  def errors
    @sources = User.where('sources.error_messages' => {"$exists" => true}).paginate(pagination_defaults).collect(&:sources).flatten
  end

  private
  def require_admin
    redirect_to dashboard_path unless current_user.is_admin?
  end
end