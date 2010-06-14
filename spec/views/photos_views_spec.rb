require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "photos/index.html.haml" do
  before :each do
    @website = Factory(:website_with_photos)
    @photos = @website.photos.paginate(:per_page => 5, :page => 1)
    assigns[:photos] = @photos
#    view.stub(:collection).and_return(@photos)
    render
  end
  it "should display photos" do
    response.should be_success
    response.should have_tag('div#photos')
    @photos.each do |photo|
      response.should have_tag("div#photo_%s.photo" % photo.id)
    end
  end
  it "should have pagination" do
    response.should have_tag('div.pagination .current')
  end
end

describe "photos/show.html.haml" do
  before :each do
    @website = Factory(:website_with_photos)
    @photo = @website.photos.first
    @photo.should_not be_nil
    assigns[:photo] = @photo
#    view.stub(:resource).and_return(@photo)
    render
  end
  it "should display photo" do
    response.should be_success
    response.should have_tag('div#photo_%i.photo' % @photo.id)
  end
end
