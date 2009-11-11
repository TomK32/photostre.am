require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Theme do
  before(:each) do
    @theme = Factory(:theme)
  end
  it "@theme should be valid" do
    @theme.should be_valid
  end

  describe "associations" do
    it { Theme.should belong_to(:author) }
    it { Theme.should belong_to(:user) }
    it { Theme.should have_many(:websites) }
  end
  
  it "should have states" do
    Theme.aasm_states.collect{|s|s.name.to_s}.sort.should ==(%w(deleted draft paid private public))
  end
  it "should protect attributes" do
    old_theme = @theme.dup
    @theme.should be_public
    @theme.user_id.should_not be(123)
    @theme.author_id.should_not be(124)
    @theme.update_attributes(:user_id => 123, :author_id => 124, :state => 'deleted', :directory => '/very-bad')
    @theme.reload
    # those don't change
    @theme.user_id.should == old_theme.user_id
    @theme.author_id.should == old_theme.author_id
    @theme.directory.should == old_theme.directory
    @theme.state.should == old_theme.state
  end
  describe "deleting a theme" do
    it "should set state to deleted"
    it "should set theme=default on all websites using the theme"
  end
  describe "versioning" do
    it "should act as versionable"
    it "should inform website owners about new major versions of the theme"
  end
end
