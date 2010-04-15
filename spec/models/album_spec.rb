require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Album do
  before :each do
    @website = Factory(:website)
    @album = @website.albums.build(Factory.build(:album).attributes)
    @album.save!
  end
  it "should be valid" do
    @album.should be_valid
  end
  
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:body_html) }
  end
  
  describe "associations" do
    it "should be embedded in a website" do
      association = Page.associations['website']
      association.klass.should ==(Website)
      association.association.should ==(Mongoid::Associations::EmbeddedIn)
      association.inverse_of.should ==(:pages)
    end
  end
  describe "status" do
    it "should have statuses" do
      Album::STATUSES.sort.should ==(%w(deleted draft published))
    end
    it "should be published by default" do
      Album.new.status.should ==("published")
    end
    it "should not allow invalid statuses" do
      album = Factory.build(:album, {:status => 'totally no possible!!1!elf!'})
      album.should_not be_valid
    end
  end
  describe "permalink" do
    it "should have a permalink" do
      @album.title.should ==('My album 0')
      @album.permalink.should ==('my-album-0')
    end
    it "should keep permalink on changing the title" do
      @album.title = 'other_title'
      @album.save
      @album.permalink.should ==('my-album-0')
    end
    it "should not validate duplicate permalinks" do
      album_with_duplicate_title = @website.albums.build(Factory.build(:album, :title => @album.title, :permalink => @album.permalink).attributes)
      album_with_duplicate_title.should_not be_valid
    end
    it "should append an index to duplicate permalinks" do
      @website.albums.collect(&:permalink).should ==(@website.albums.collect(&:permalink).uniq)
      @album.permalink.should_not be_blank
      album_with_duplicate_title = @website.albums.build(Factory.build(:album, :title => @album.title).attributes)
      album_with_duplicate_title.save
      
      @album.permalink.should_not ==(album_with_duplicate_title.permalink)
      @album.title.should ==(album_with_duplicate_title.title)
      @website.albums.collect(&:permalink).should ==(@website.albums.collect(&:permalink).uniq)
    end
    
  end
  
  it "should set body_html" do
    @album.body = 'Hello this is a new body'
    @album.save
    @album.body_html.should =='<p>Hello this is a new body</p>'
  end
  describe "key photo" do
    before :each do
      (0..5).collect { @album.related_photos.create( :photo => Factory(:photo)) }
      @album.save!
    end
    it "should return the first photo as key" do
      @album.key_photo.should ==(@album.photos[0])
    end
    it "should allow changing the key photo" do
      @album.key_photo.should_not be(@album.photos[2])
      @album.key_photo_id = @album.photos[2].id
      @album.save
      @album.key_photo.should ==(@album.photos[2])
    end
  end
  describe "sortable tree" do
    it "should belong to a parent"
    it "should have children"
    
    it "should have roots" do
      album2 = @website.albums.create(:title => 'album 2')
      album3 = @website.albums.create(:title => 'album 3')
      @website.albums << album2
      @website.albums << album3
      @website.save
      @website.reload
      @website.albums.should == [@album, album2, album3]
      @website.albums.roots.should == [@album, album2]
      album2.children.should == [album3]
      album3.parent.should == album2
    end
  end
end
