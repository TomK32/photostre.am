require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StaticController do

  it "should serve any kind of pages" do
    get 'static/about'
    response.should be_success
    get 'about'
    response.should be_success
    get 'static/index'
    response.should be_success
    assert_raise(ActionController::UnknownAction) do
      get 'static2/index'
    end
  end
  it "should serves only on system websites"

end
