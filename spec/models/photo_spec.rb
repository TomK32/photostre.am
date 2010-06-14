require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Photo do
  before(:each) do
    @photo = Factory.build(:photo)
  end

  it "should be valid" do
    @photo.should be_valid
  end
  describe "associations" do
    it { should belong_to_related(:user) }
    it { should belong_to_related(:source) }
    it { should belong_to_related(:related_photo) }
  end
  describe "attributes" do
    it { should have_field(:tags).of_type(Array) }
    it { should have_field(:title).of_type(String) }
    it { should have_field(:description).of_type(String) }
  end
  describe "validations" do
    it { should validate_presence_of(:title) }
  end
end
