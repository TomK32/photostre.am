require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe Source do
  before(:each) do
    @source = Factory(:source)
  end
  it "@source should be valid" do
    @source.should be_valid
  end
  describe "associations" do
    it { should be_embedded_in(:users).as_inverse_of(:sources) }
    it { should have_many_related(:photos) }
  end
  describe "statuses" do
    it "should have statuses" do
      Source::STATUSES.sort.should ==(%w(active deleted inactive updating))
    end
  end
  describe "scopes" do
    it "should have :active scope" do
      @source.update_attributes(:active => true)
      active_sources = Source.all(:conditions => {:active => true}).to_a
      Source.active.to_a.should == active_sources
      @source.update_attributes(:active => false)
      Source.active.to_a.should == active_sources.reject!{|w| w.id == @source.id }
    end
  end
end
