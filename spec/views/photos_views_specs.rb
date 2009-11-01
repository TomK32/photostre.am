require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "photos/index" do
  before :each do
    @website = Factory(:website_with_photos)
    @photos = @website.photos.paginate(:per_page => 5, :page => 1)
    template.stub(:current_objects).and_return(@photos)
    render
  end
  it "should display photos" do
    response.should be_success
    response.should have_tag('div#photos')
    @website.photos.each do |photo|
      response.should have_tag("div#photo_%s" % photo.id)
    end
    response.should have_tag('div.pagination')
  end
end

