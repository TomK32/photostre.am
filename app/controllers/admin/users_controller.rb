class Admin::UsersController < Admin::ApplicationController
  inherit_resources
  actions :create, :edit, :new, :update
  def update
    update! {
      redirect_to dashboard_path and return
    }
  end
  def create
    create! {
      redirect_to dashboard_path and return
    }
  end
end
