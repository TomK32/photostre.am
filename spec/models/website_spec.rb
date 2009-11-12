require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Website do
  before(:each) do
    @website = Factory(:website)
  end
  it "@website should be valid" do
    @website.should be_valid
  end
  describe "associations" do
    it { Website.should have_and_belong_to_many(:users) }
    it { Website.should have_many(:sources) }
    it { Website.should belong_to(:theme) }
  end
  describe "validations" do
    it "should validate for presence of domain" do
      @website.domain = nil
      @website.should_not be_valid
    end
    it "should validate for presence of state" do
      @website.state = nil
      @website.should_not be_valid
    end
    it "should validate for presence of site title" do
      @website.site_title = nil
      @website.should_not be_valid
    end
  end
  describe "scopes" do
    it "should have scopes" do
      Website.aasm_states.collect{|s|s.name.to_s}.sort.should ==(%w(active deleted draft system))
    end
    it "should have named scope active_or_styem" do
      system_website = Factory(:website, :state => 'system')
      Website.active_or_system.count.should == Website.all.count
      Website.active.count.should ==(Website.all.count - 1)
      Website.system.count.should == 1
    end
  end

  describe "creating a new website" do
    it "should create a standard homepage" do
      new_website = Factory(:website)
      new_website.pages.find_by_permalink('homepage').should be_published
      new_website.pages.find_by_permalink('about').should be_published
      new_website.pages.find_by_permalink('contact').should be_published
      new_website.root_path.should ==('/pages/homepage')
    end
  end
  it "should denormalize theme_path" do
    @website.theme.should be_nil
    @website.theme_path.should ==('default')
    theme = Factory(:theme, :directory => 'funky')
    @website.theme = theme
    @website.save
    @website.theme_path.should ==(theme.directory)
  end
end
