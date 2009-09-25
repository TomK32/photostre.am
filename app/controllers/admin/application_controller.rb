class Admin::ApplicationController < ApplicationController
  layout 'admin/application'
  before_filter :authenticated
  include Authentication

  def authenticated?
    ! current_identity.nil?
  end

end