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

  embedded_in :website, :inverse_of => :pages

  def children
    self.website.pages.published.where({:parent_id => self.id})
  end

  alias_attribute :meta_description, :excerpt
  alias_attribute :meta_keywords, :tags

  scope :orderd, :order_by => [:parent_id, :asc, :position, :asc]
  scope :published, :where => {:public => true}
  scope :roots, :where => {:parent_id => ''} # FIXME shouldn't that be nil?

  validates_presence_of :title, :body, :permalink
  validates_uniqueness_of :permalink

  before_validate :denormalize_body_and_excerpt
  before_validate :set_permalink

  STATUSES = %w(published draft deleted)
  STATUSES.each do |s|
    define_method("#{s}?".to_sym) { status == s}
    scope s.to_sym, :where => {:status => s}
  end

  def denormalize_body_and_excerpt
    self.body_html = textilize(html_escape(self.body))
    self.excerpt_html = textilize(html_escape(self.excerpt))
  end

  def set_permalink
    self.permalink ||= self.title.underscore
  end
  def tag_list=(new_tags)
    self.tags = new_tags.to_s.split(/, /).uniq
  end
  def tag_list
    [self.tags].flatten.join(', ')
  end
end
