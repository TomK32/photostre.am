require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "layouts/application" do
  before :each do
    @website = Factory(:website_system, :tracking_code => 'this is some tracking code')
    template.stub(:current_website).and_return(@website)
  end
  it "should display tracking_code" do
    render
    response.should be_success
    response.should have_text(/#{@website.tracking_code}/)
  end
end

