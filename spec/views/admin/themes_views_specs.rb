require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "admin/themes/new" do
  before :each do
    @theme = Factory(:theme)
    template.stub(:current_object).and_return(Theme.new)
    template.stub(:objects_path).and_return('/admin/themes')
    render
  end
  it "should have fields" do
    response.should be_success
    response.should have_form_posting_to('/admin/themes')
    response.should have_text_field_for :theme, :name
    response.should have_text_field_for :theme, :directory
    response.should have_text_field_for :theme, :license
    response.should have_text_area_for :theme, :description
    # TODO missing or maybe buggy matcher
    #response.should have_select_for :domain
    response.should have_tag('input#subdomain')
    response.should have_tag('select#domain')
  end
  it "should display system domains in drop down" do
    response.should have_tag('select#domain') do |tag|
      # FIXME
      tag.should have_tag('option')
    end
    
  end
end

