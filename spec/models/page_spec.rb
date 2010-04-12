require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  before :each do
    @website = Factory(:website)
    @page = @website.pages.build(Factory.build(:page).attributes)
    @page.save!
  end

  it "should be valid" do
    @page.should be_valid
  end

  it "should protect attributes"

  describe "permalink" do
    it "should have a permalink" do
      @page.title.should ==('My page 0')
      @page.permalink.should ==('my-page-0')
    end
    it "should keep permalink on changing the title" do
      @page.title = 'other_title'
      @page.save
      @page.permalink.should ==('my-page-0')
    end
    it "should have a scope on the permalink"
  end
  describe "associations" do
    it "should be embedded in a website" do
      association = Page.associations['website']
      association.klass.should ==(Website)
      association.association.should ==(Mongoid::Associations::EmbeddedIn)
    end
    it "should belong to related user" do
      association = Page.associations['user']
      association.klass.should ==(User)
      association.association.should ==(Mongoid::Associations::BelongsToRelated)
    end
  end
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:body_html) }
  end
  
  it "should have statuses" do
    Page::STATUSES.sort.should ==(%w(deleted draft published))
  end
  it "should have a default scope ordering by parent and position"
  it "should keep status when being edited" do
    @page.update_attributes(:status => 'deleted',
        :body => 'A completely updated page body')
    @page.status.should ==('deleted')
    @page.body_html.should ==('<p>A completely updated page body</p>')
  end
  describe "tags" do
    it "should have tags as an Array" do
      @page.tags.should be_a(Array)
    end
    it "should have tag_list as a String" do
      @page.tag_list.should be_a(String)
    end
  end
  describe "sortable tree" do
    it "should have a parent"
    it "should have children"
    it "should have roots" do
      @website.pages.count.should == 4
      @website.pages[1].update_attributes(:parent_id => @website.pages[0])
      @website.pages[2].update_attributes(:parent_id => @website.pages[1])
      @website.reload
      @website.pages.roots.should ==([@website.pages[0]])
      @website.pages[0].children.should ==([@website.pages[1]])
      @website.pages[1].children.should ==([@website.pages[2]])
      @website.pages[1].parent.should ==(@website.pages[0])
      @website.pages[2].parent.should ==(@website.pages[1])
    end
  end
  describe "denormalizers for body and excerpt" do
    it "should set body_html" do
      @page.body = "This is a different body than before"
      @page.save
      @page.body_html.should ==('<p>This is a different body than before</p>')
    end
    it "should set excerpt_html" do
      @page.excerpt = "This is a different excerpt than before"
      @page.save
      @page.excerpt_html.should ==('<p>This is a different excerpt than before</p>')

      @page.excerpt = nil
      @page.save
      @page.excerpt_html.should ==('')
    end
  end
end
