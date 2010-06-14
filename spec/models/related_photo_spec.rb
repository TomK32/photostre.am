require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RelatedPhoto do
  before(:each) do
    @website = Factory(:website_with_albums)
    @related_photo = @website.albums.first.related_photos.build(Factory.build(:related_photo).attributes)
    @related_photo.save
  end
  it "@related_photo should be valid" do
    @related_photo.should be_valid
  end

  describe "associations" do
    it { should belong_to_related :photo }
    it { should be_embedded_in(:parent) }
  end
  describe "fields" do
    it { should have_field(:permalink) }
  end
  
  describe "validations" do
    it { should validate_presence_of(:permalink) }
  end

  it "should have a permalink based on the photo's title" do
    @related_photo.permalink.should ==(@related_photo.photo.title.to_permalink)
  end
  it "should not change the permalink if the photo's title changes" do
    @photo = @related_photo.photo
    @photo.update_attributes(:title => 'A different title')
    @photo.save!
    related_photo = @website.reload.related_photos.find(@related_photo.id)
    related_photo.should_not ==(@photo.title.to_permalink)
  end
end
