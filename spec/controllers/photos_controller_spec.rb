require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PhotosController do
  fixtures :websites, :photos

  describe "GET to :index" do
    before :each do
      get :index
    end
    it "assign @photos" do
      assigns[:photos].should == Photo.published(:all, :limit => 10)
    end
  end
  describe "GET to :show" do
    it "should assign @photo for id" do
      get :show, :id => '1'
      assigns[:photo].should == Photo.find(1)
    end
    it "should assign @photo for permalink" do
      get :show, :id => 'self-portrait'
      assigns[:photo].should == Photo.find(1)
    end
    it "should redirect to :index for non-existing photo" do
      get :show, :id => 'no-such-photo'
      assert_not_nil flash[:error]
      assert_response 404
      assert_template 'photos/index'
    end
  end
end
