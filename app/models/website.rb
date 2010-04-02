class Website
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String, :required => true
  field :status, :type => String, :default => 'active', :required => true
  field :user_ids, :type => Array, :default => []
  field :photo_ids, :type => Array, :default => []
  field :domains, :type => Array, :default => []
  field :description, :type => String
  field :tracking_code, :type => String
  field :root_path, :type => String
  field :tags, :type => Array
  has_many :photos, :class_name => 'RelatedPhoto'
  has_many :related_photos

  has_many :pages
  has_many :albums
  has_one :theme
  belongs_to_related :theme
  alias_attribute :meta_keywords, :tags

  scope :latest, :order_by => [:updated_at, :desc]
  scope :active_or_system, :where => {:status.in => %w(active system)}
  scope :active, :where => {:status => %w(active)}
  after_create :create_default_pages

  validates_true_for :domains, :logic => lambda {
    result = [! domains.empty?]
    result << domains.collect {|domain| ! Website.where(:domains => domain).count == 0 }
    result.include?(true)
  }

  STATUSES = %w(inactive active system deleted)
  STATUSES.each do |s|
    define_method("#{s}?".to_sym) { status == s}
    scope s.to_sym, :where => {:status => s}
  end

  def theme
    attributes[:theme] || Theme.new(:directory => :default)
  end

  def url(domain = nil)
    'http://' + (domain || self.domains.first)
  end

  def tag_list=(new_tags)
    self.tags = new_tags.to_s.split(/, /).uniq
  end
  def tag_list
    [self.tags].flatten.join(', ')
  end

  def create_default_pages
    return if self.system?
    [self.pages.create(:title => 'Home', :body => 'Welcome to the photo portfolio of %s' % self.title),
    self.pages.create(:title => 'About', :body => 'Want to know more about %s?' % self.title),
    self.pages.create(:title => 'Contact', :body => 'The contact details of %s are yet missing.' % self.title)].each do |page|
      page.user = self.user_ids.first # still could be nil
      page.save!
    end
    self.root_path = '/pages/' + self.pages.first.permalink
  end
end
