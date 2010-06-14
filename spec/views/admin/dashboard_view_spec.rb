require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "admin/dashboard/index" do
  describe "without any data" do
    before :each do 
      assigns[:websites] = assigns[:photos] = assigns[:sources] = []
      view.should_receive(:current_user).and_return(Factory(:user))
    end
    it "should render" do
      render
    end
    it "should have link to create new website"
    it "should have link to add a photo source"
  end
  describe "with data" do
    def setup
      @user = Factory(:user)
      @system_website = Website.system.first || Factory(:website_system)
      @websites = [Factory(:website, :domains => ['user.com']),
        Factory(:website, :domains => ['subdomain.user.com'])]
    end
    before :each do
      assigns[:current_user] = @user
      assigns[:websites] = @websites
      assigns[:photos] = (0..30).collect{ Factory(:photo, :user_id => @user.id) }
      assigns[:sources] = []
      render
    end
    it "should show number of websites" do
      response.should_have_tag('#websites').with_text(/#{@user.website.count} website/)
    end
    it "should show latest photos" do
    end
  end
end

