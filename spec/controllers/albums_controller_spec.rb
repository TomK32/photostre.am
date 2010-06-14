require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PhotosController do
  def setup
    @website = Factory(:website, :domains => %w(tomk32.de))
    @album = @website.albums.build(Factory.build(:album).attributes)
    @album.save
    @draft_album = @website.albums.build(Factory.build(:album, :status => 'draft').attributes)
    @draft_album.save
    @deleted_album = @website.albums.build(Factory.build(:album, :status => 'deleted').attributes)
    @deleted_album.save
  end

  describe "GET to :index" do
    before :each do
      @controller.request.host = 'tomk32.de'
    end
    it "assigns current_website" do
      
      get :index
      assigns["current_website"].should ==(@website)
      assigns["current_website"].should_not be_nil
    end
    it "assigns current_objects" do
      assigns[:albums].should ==(@website.albums)
    end
    it "assigns only published photos"
    it "has pagination"
    it "allows passing a per_page to current_objects"
    it "shows only albums of the current website"
  end

  describe "GET to :show" do
    before :each do
      @album = Album.first || Factory(:album)
      get :show, {:id => @album.permalink}
    end
    it "shows album by permalink or id"
  end

  it "should not show draft albums" do
    draft_album = @website.albums.where(:status => "draft").first
    draft_album.should_not be_nil
    get :show, :id => draft_album.permalink
    assert_response 404
  end
  it "should not show deleted albums" do
    deleted_album = @website.albums.where(:status => 'deleted').first
    get :show, :id => deleted_album.permalink
    assert_response 404
  end

  it "should not show an album belonging to a different website" do
    other_website = Factory(:website_with_albums_and_photos)
    other_album = other_website.albums.first
    @website.albums.collect(&:id).should_not include(other_album.id)

    get :show, :id => other_album.permalink
    assigns[:current_object].should be(nil)
    assert_response 404
  end
end
