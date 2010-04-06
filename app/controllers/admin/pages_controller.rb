class Admin::PagesController < Admin::ApplicationController
  inherit_resources
  actions :all
  belongs_to :website

  before_filter :owner_required

  private
  def owner_required
    super(parent)
  end
end
