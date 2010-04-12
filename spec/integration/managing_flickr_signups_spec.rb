require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "FlickrSignups" do
  before(:each) do
    @valid_attributes = {
    }
  end

  describe "viewing index" do
    it "lists all FlickrSignups" do
      flickr_signup = FlickrSignup.create!(@valid_attributes)
      visit flickr_signups_path
      response.should have_selector("a", :href => flickr_signup_path(flickr_signup))
    end
  end
end
