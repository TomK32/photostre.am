require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "admin/websites/new" do
  before :each do
    assigns[:current_user] = @user = Factory(:user)
    Factory(:website_system)
    @website = Factory(:website, :domains => ['user.com'], :user_ids => [@user.id])
    @photos = @website.photos.paginate(:per_page => 5, :page => 1)
    template.stub(:objects_path).and_return('/admin/websites')
    template.stub(:current_object).and_return(Website.new)
  end
  it "should have fields for existing website" do
    template.stub(:current_object).and_return(Factory(:website))
    render
    response.should be_success
    response.should have_form_posting_to('/admin/websites')
    response.should have_text_field_for :website, :site_title
    response.should have_text_field_for :website, :meta_keywords
    response.should have_text_field_for :website, :description
    response.should_not have_text_field_for :website, :domain
    response.should have_text_area_for :website, :tracking_code
    # TODO missing or maybe buggy matcher
    #response.should have_select_for :domain
    response.should_not have_tag('input#subdomain')
    response.should_not have_tag('select#domain')
  end
  it "should have fields for new website" do
    template.stub(:current_object).and_return(Website.new)
    render
    response.should have_tag('input#subdomain')
    response.should have_tag('select#domain')
  end
  it "should display system domains in drop down" do
    render
    response.should have_tag('select#domain') do |tag|
      # FIXME
      tag.should have_tag('option')
    end
    
  end
end

