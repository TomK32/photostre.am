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
    conditions = {'sources.status' => "updating"}
    # for a single user we also reactivate the inactive/faulty ones.
    conditions = {:user_id => BSON::ObjectId(params[:user_id])} if params[:user_id]
    User.collection.update(conditions, {'$set' => {'sources.$.status' => 'active'}}, :multi => true)
    respond_to do |format|
      format.html { redirect_to :action => :index }
      format.js { render :json => :success and return }
    end
  end

  def update_active_sources
    scope = User.only(:sources)
    # Optionally limit to only one user
    scope = scope.where(:_id => BSON::ObjectId(params[:user_id])) if params[:user_id]
    scope.all.map{|u| puts u.sources.map(&:to_s); u.sources.map(&:call_worker)}
    respond_to do |format|
      format.html { redirect_to :action => :index }
      format.js { render :json => :success and return }
    end
  end

  def websites
    @websites = Website.order_by([:created_at, :desc]).paginate(pagination_defaults)
  end
  def users
    @users = User.order_by([:created_at, :desc]).paginate(pagination_defaults)
  end
  def errors
    @sources = User.where('sources.error_messages' => {"$exists" => true}).paginate(pagination_defaults)
  end
  def jobs
    @jobs = Navvy::Job.paginate(pagination_defaults)
  end

  private
  def require_admin
    redirect_to dashboard_path unless current_user.is_admin?
  end
end