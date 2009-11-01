require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Website do
  before(:each) do
    @website = Factory(:website)
  end
  it "@website should be valid" do
    @website.should be_valid
  end
  describe "associations" do
    it "should have and belong to many users" do
      @website.should have_and_belong_to_many(:users)
    end
    it "should have and belong to many sources" do
      @website.should have_many(:sources)
    end
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
    it "should have named scope active that also includes system websites" do
      system_website = Factory(:website, :state => 'system')
      Website.active.count.should == Website.all.count
      Website.system.count.should == 1
    end
  end
end
