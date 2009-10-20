require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Album do
  before(:each) do
    @album = Factory(:album)
    @new_album = Factory.build(:album)
  end
  it "should be valid" do
    @album.should be_valid
  end
  
  describe "validations" do
    it { @album.should validate_presence_of(:website_id) }
    it { @album.should validate_presence_of(:title) }
#    it { @album.should validate_presence_of(:body) }
  end
  describe "associations" do
    it { Album.should belong_to(:website) }
    it { Album.should belong_to(:parent) }
    it { Album.should have_many(:children) }
    it { Album.should belong_to(:key_photo) }
  end
  describe "state" do
    it "should have states" do
      Album.aasm_states.collect{|s|s.name.to_s}.sort.should ==(%w(deleted draft published))
    end
  end
  describe "permalink" do
    it "should have a permalink" do
      @album.title.should ==('My album 0')
      @album.permalink.should ==('my-album-0')
      new_album = Factory(:album, { :title => 'Title 123 '})
      new_album.permalink.should ==('title-123')
    end
    it "should have a scope on the permalink" do
      album_on_other_website = Factory(:album, :website => Factory(:website), :title => @album.title)
      album_on_other_website.website_id.should_not ==(@album.website_id)
      album_on_other_website.permalink.should ==(@album.permalink)
    end
  end
  
  it "should set body_html" do
    @new_album.body = 'Hello this is my website'
    @new_album.body_html.should be_nil
    @new_album.save
    @new_album.body_html.should =='<p>Hello this is my website</p>'
  end
  describe "key photo" do
    before :each do
      @photos = (0..5).collect { Factory(:photo) }
      @new_album.photos << @photos
      @new_album.save!
      @new_album.reload
    end
    it "should set the first photo as key" do
      @new_album.key_photo.should ==(@photos.first)
      @new_album.key_photo_thumbnail_url.should ==(@photos.first.thumbnail_url)
      @new_album.key_photo_medium_url.should ==(@photos.first.medium_url)
    end
    it "should allow changing the key photo" do
      @new_album.key_photo.should ==(@photos.first)
      @new_album.key_photo = @photos[2]
      @new_album.save
      @new_album.reload
      @new_album.key_photo.should ==(@photos[2])
      @new_album.key_photo_thumbnail_url.should ==(@photos[2].thumbnail_url)
      @new_album.key_photo_medium_url.should ==(@photos[2].medium_url)
    end
  end
  describe "sortable tree" do
    it "should have roots" do
      album2 = Factory(:album) # published by default
      album3 = Factory(:album, :parent => album2) # published by default
      album2.reload
      album3.reload
      Album.all.should == [@album, album2, album3]
      Album.roots.should == [@album, album2]
      album2.children.should == [album3]
      album3.parent.should == album2
    end
  end
end
