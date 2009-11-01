require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  before(:each) do
    @page = Factory(:page)
    @new_page = Factory.build(:page)
  end

  it "should be valid" do
    @page.should be_valid
    Page.count.should be(1)
  end

  it "should protect attributes" do
    old_page = @page.dup
    @page.should be_published
    @page.website_id.should_not be(123)
    @page.update_attributes(:user_id => 123, :website_id => 123, :state => 'deleted')
    @page.reload
    # those don't change
    @page.user_id.should == old_page.user_id
    @page.website_id.should == old_page.website_id
    # but e.g state does
    @page.should be_deleted
  end

  describe "permalink" do
    it "should have a permalink" do
      @page.title.should ==('My page 0')
      @page.permalink.should ==('my-page-0')
      new_page = Factory(:page, { :title => 'Title 123 '})
      new_page.permalink.should ==('title-123')
    end
    it "should have a scope on the permalink" do
      page_on_other_website = Factory(:page, :website => Factory(:website), :title => @page.title)
      page_on_other_website.website_id.should_not ==(@page.website_id)
      page_on_other_website.permalink.should ==(@page.permalink)
    end
  end
  describe "associations" do
    it { Page.should belong_to(:website) }
    it { Page.should belong_to(:user) }
    it { Page.should belong_to(:parent) }
    it { Page.should have_many(:children) }
  end
  describe "validations" do
    it { @page.should validate_presence_of(:website_id) }
    it { @page.should validate_presence_of(:user_id) }
    it { @page.should validate_presence_of(:title) }
    it { @page.should validate_presence_of(:body) }
  end
  describe "scopes" do
    before :each do
      # there's already @page which is published
      Factory(:page) # published by default
      Factory(:page, :state => 'draft')
      Factory(:page, :state => 'deleted')
      Page.count.should be(4)
    end
    it "should have a default scope ordering by parent and position" do
      @page.default_scoping[0][:find].should ==({:order => 'parent_id ASC, position ASC'})
    end
    it "should have scopes" do
      Page.aasm_states.collect{|s|s.name.to_s}.sort.should ==(%w(deleted draft published))
    end
    it "should have a published scope" do
      Page.published.count.should be(2)
    end
    it "should have a deleted scope" do
      Page.deleted.count.should be(1)
    end
    it "should have a draft scope" do
      Page.draft.count.should be(1)
    end
    it "should keep state when being edited" do
      @page.state = 'deleted'
      @page.body = 'A completely update page body'
      @page.save! and @page.reload
      @page.state.should =='deleted'
    end
  end
  describe "meta tags" do
    it "should have meta_keywords" do
      @page.meta_keywords.should == @page.tag_list
    end
    it "should have meta_description" do
      @page.meta_description.should == @page.excerpt
    end
  end
  describe "sortable tree" do
    it "should have roots" do
      page2 = Factory(:page) # published by default
      page3 = Factory(:page, :parent => page2) # published by default
      page2.reload
      page3.reload
      Page.all.should == [@page, page2, page3]
      Page.roots.should == [@page, page2]
      page2.children.should == [page3]
      page3.parent.should == page2
    end
  end
  describe "denormalizers for body and excerpt" do
    it "should set body_html" do
      @new_page.body = 'Hello this is my website'
      @new_page.body_html.should be_nil
      @new_page.save
      @new_page.body_html.should =='<p>Hello this is my website</p>'
    end
    it "should set excerpt_html" do
      @new_page.excerpt = 'fancy intro'
      @new_page.excerpt_html.should be_nil
      @new_page.save
      @new_page.excerpt_html.should =='<p>fancy intro</p>'
    end
  end
end
