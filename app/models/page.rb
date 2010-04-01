class Page
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String, :required => true
  field :permalink, :type => String
  field :excerpt, :type => String
  field :excerpt_html, :type => String
  field :body, :type => String, :required => true
  field :body_html, :type => String, :required => true
  field :status, :type => String, :default => 'published'
  field :tags, :type => Array
  field :parent_id, :type => String
  
  index :permalink, :unique => true
  key :permalink

#  attr_accessible :title, :body, :excerpt, :permalink, :tags, :position, :parent_id, :status
#  attr_accessible :meta_geourl

belongs_to_related :user

  belongs_to :website, :inverse_of => :pages

  def children
    self.website.pages.published.where({:parent_id => self.id})
  end

  alias_attribute :meta_description, :excerpt
  alias_attribute :meta_keywords, :tags

  scope :orderd, :order_by => [:parent_id, :asc, :position, :asc]
  scope :published, :where => {:public => true}
  scope :roots, :where => {:parent_id => nil}

  validates_presence_of :title, :body, :body_html, :permalink, :user_id
  validates_uniqueness_of :permalink

  before_validation :denormalize_body_and_excerpt

  STATUSES = %w(published draft deleted)
  STATUSES.each do |s|
    define_method("#{s}?".to_sym) { status == s}
    scope s.to_sym, :where => {:status => s}
  end

  def denormalize_body_and_excerpt
    self.body_html = textilize(self.body)
    self.excerpt_html = textilize(self.excerpt)
  end

end
