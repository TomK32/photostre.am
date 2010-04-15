require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Website do
  before(:each) do
    Website.delete_all
    @website = Factory(:website)
  end
  it "@website should be valid" do
    @website.should be_valid
  end
  describe "associations" do
    it "should have user_ids" do
      @website.user_ids.should be_a(Array)
      @website.user_ids.first.should be_a(String)
      User.find(@website.user_ids[0]).id.should ==(@website.user_ids[0])
    end
    it "should embed a theme" do
      association = Website.associations['theme']
      association.klass.should ==(Theme)
      association.association.should ==(Mongoid::Associations::EmbedsOne)
    end
    it "should embed many albums" do
      association = Website.associations['albums']
      association.klass.should ==(Album)
      association.association.should ==(Mongoid::Associations::EmbedsMany)
    end
  end
  describe "validations" do
    it "should validate for presence of domain" do
      @website.domains = nil
      @website.should_not be_valid
      @website.domains = []
      @website.should_not be_valid
    end
    it "should not validate duplicate domain names" do
      website2 = Factory(:website, :domains => @website.domains)
      website2.domains.should ==(@website.domains)
      website2.should_not be_valid
    end

# NOTE There's a default value for status and mongoid just ignores my nil!
#    it "should validate for presence of status" do
#      @website.status = nil
#      @website.should_not be_valid
#    end
    it "should validate for presence of title" do
      @website.title = nil
      @website.should_not be_valid
    end
  end
  describe "scopes" do
    it "should have scopes" do
      Website::STATUSES ==(%w(active deleted draft system))
    end
    it "should have named scope active_or_styem" do
      system_website = Factory(:website, :status => 'system')
      Website.active_or_system.count.should == Website.all.count
      Website.active.count.should ==(Website.all.count - 1)
      Website.system.count.should == 1
    end
  end

  describe "creating a new website" do
    it "should create a standard homepage" do
      new_website = Factory(:website)
      new_website.reload
      new_website.pages.count.should be(3)
      new_website.pages.collect(&:permalink).sort.should == %w(about contact home)
      new_website.pages.collect(&:status).sort.should == %w(published published published)
      new_website.root_path.should ==('/pages/home')
    end
    it "should not create standard pages for system websites"
  end
end
