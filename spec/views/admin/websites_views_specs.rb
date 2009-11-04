require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "admin/websites/new" do
  before :each do
    assigns[:current_user] = @user = Factory(:user)
    Factory(:website_system)
    @website = Factory(:website, :domain => 'user.com')
    @website.users << @user
    @photos = @website.photos.paginate(:per_page => 5, :page => 1)
    template.stub(:current_object).and_return(Website.new)
    template.stub(:objects_path).and_return('/admin/websites')
    render
  end
  it "should have fields" do
    response.should be_success
    response.should have_form_posting_to('/admin/websites')
    response.should have_text_field_for :website, :site_title
    response.should have_text_field_for :website, :meta_keywords
    response.should have_text_field_for :website, :description
    response.should have_text_field_for :website, :domain
    # TODO missing or maybe buggy matcher
    #response.should have_select_for :domain
    response.should have_tag('input#subdomain')
    response.should have_tag('select#domain')
  end
  it "should display system domains in drop down" do
    response.should have_tag('select#domain') do |tag|
      # FIXME
      tag.should have_tag('option[value=user.com]')
    end
    
  end
end

