class Page
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, :type => String, :default => 'published'
  
  index :permalink, :unique => true
  key :permalink

#  attr_accessible :title, :body, :excerpt, :permalink, :tags, :position, :parent_id, :status
#  attr_accessible :meta_geourl

#  has_permalink :title, :scope => :website_id
  belongs_to :website, :inverse_of => :pages
  belongs_to_related :user
  def children
    self.website.pages.published.where({:parent_id => self.id})
  end

  alias_attribute :meta_description, :excerpt
  alias_attribute :meta_keywords, :tag_list

  scope :orderd, :order_by => [:parent_id, :asc, :position, :asc]
  scope :published, :where => {:public => true}
  scope :roots, :where => {:parent_id => nil}


  validates_presence_of :title, :body, :body_html, :permalink
  validates_presence_of :website_id, :user_id

  before_validation :denormalize_body_and_excerpt

  def denormalize_body_and_excerpt
    self.body_html = textilize(self.body)
    self.excerpt_html = textilize(self.excerpt)
  end

end
