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
    it { @album.should validate_presence_of :website_id }
    it { @album.should validate_presence_of :title }
    it { @album.should validate_presence_of :body }
  end
  describe "associations" do
    it { Album.should belong_to :website }
    it { Album.should belong_to :parent }
    it { Album.should have_many :children }
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
end
