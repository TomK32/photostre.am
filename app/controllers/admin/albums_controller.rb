class Admin::AlbumsController < Admin::ApplicationController
  inherit_resources
  actions :all
  belongs_to :website

  before_filter :owner_required

  def show
    @photos = resource.related_photos.paginate(pagination_defaults)
    show!
  end

  private
  def owner_required
    super(parent)
  end
end
