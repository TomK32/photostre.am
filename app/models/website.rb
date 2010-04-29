class Website
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String, :required => true
  field :status, :type => String, :default => 'active', :required => true
  field :user_ids, :type => Array, :default => []
  field :domains, :type => Array, :default => []
  index :domains
  field :description, :type => String
  field :tracking_code, :type => String
  field :root_path, :type => String, :default => '/pages/home'
  field :screenshot_filename, :type => String
  field :tags, :type => Array
  field :related_photos, :type => Array
  field :theme_path, :type => String, :default => 'default'

  embed_many :related_photos
  
  before_validate :set_theme_path
  alias_attribute :photos, :related_photos

  validates_presence_of :title
  validates_presence_of :domains
  validates_presence_of :status
  validates_presence_of :theme_path

  embed_many :pages
  embed_many :albums
  belongs_to_related :theme
  alias_attribute :meta_keywords, :tags

  scope :latest, :order_by => [:updated_at, :desc]
  scope :active_or_system, :where => {:status.in => %w(active system)}
  scope :active, :where => {:status => %w(active)}
  after_create :create_default_pages

  validate do
    domains.each do |domain|
      errors.add(:domains, '%s is duplicate' % domain) if Website.where(:domains => domain).where(:_id.ne => id).count > 0
    end
  end

  STATUSES = %w(inactive active system deleted)
  STATUSES.each do |s|
    define_method("#{s}?".to_sym) { status == s}
    scope s.to_sym, :where => {:status => s}
  end

  def theme_with_default
    theme_without_default || Theme.new(:directory => (system? ? 'system' : 'default'))
  end
  alias_method_chain :theme, :default

  def set_theme_path
    self.theme_path = theme.directory
  end

  def url(domain = nil)
    ['http://', (domain || self.domains.first)].join
  end

  def tag_list=(new_tags)
    self.tags = new_tags.to_s.split(/, /).uniq
  end
  def tag_list
    [self.tags].flatten.join(', ')
  end

  def create_default_pages
    return if self.system?
    [self.pages.build(:title => 'Home', :body => 'Welcome to the photo portfolio of %s' % self.title),
    self.pages.build(:title => 'About', :body => 'Want to know more about %s?' % self.title),
    self.pages.build(:title => 'Contact', :body => 'The contact details of %s are yet missing.' % self.title)].each do |page|
      page.user_id = self.user_ids.first
      page.save!
    end
    self.root_path = '/pages/' + self.pages.first.permalink
  end
end
