require 'spec_helper'

describe "photos/index.html.haml" do
  before :each do
    @website = Factory(:website_with_photos)
    @photos = @website.photos.paginate(:per_page => 5, :page => 1)
    assign :photos, @photos
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
    @photo = @website.photos[4]
    puts @photo.source.inspect
    assign :photo, @photo
    render
  end
  it "should display photo" do
    response.should be_success
    response.should have_tag('div#photo_%i.photo' % @photo.id)
  end
end
