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
  field :tags, :type => Array
  field :related_photos, :type => Array
  embed_many :related_photos
  alias_attribute :photos, :related_photos

  validates_presence_of :title
  validates_presence_of :domains
  validates_presence_of :status

  embed_many :pages
  embed_many :albums
  embed_one :theme
  alias_attribute :meta_keywords, :tags

  scope :latest, :order_by => [:updated_at, :desc]
  scope :active_or_system, :where => {:status.in => %w(active system)}
  scope :active, :where => {:status => %w(active)}
  after_create :create_default_pages

  def validate
    result = [domains.empty?]
    result << domains.collect {|domain| Website.where(:domains => domain).count > 0 }
    errors[:domains].add t(:'.unique') if result.flatten.include?(true)
  end

  STATUSES = %w(inactive active system deleted)
  STATUSES.each do |s|
    define_method("#{s}?".to_sym) { status == s}
    scope s.to_sym, :where => {:status => s}
  end

  def theme
    attributes[:theme] || Theme.new(:directory => :default)
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
