require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "admin/themes/new" do
  def setup
    @theme = Factory(:theme)
  end
  before :each do
    view.stub(:resource).and_return(Theme.new)
    view.stub(:collection_path).and_return('/admin/themes')
    render
  end
  it "should have fields" do
    response.should be_success
    response.should have_form_posting_to('/admin/themes') do
      with_text_field_for :theme, :nam
      with_text_field_for :theme, :directory
      with_text_field_for :theme, :license
      with_text_area_for :theme, :description
      with_select_for :theme_parent_id
      with_select_for :theme, :select
      assert nil == 2
    end
  end
end

