class Website
  include Mongoid::Document
  include Mongoid::Timestamps

  field :site_title, :type => String, :required => true
  field :status, :type => String, :default => 'active', :required => true
  field :user_ids, :type => Array
  field :photo_ids, :type => Array
  field :domains, :type => Array
  field :description, :type => String
  field :tracking_code, :type => String
  has_many :photos, :class_name => 'RelatedPhoto'
  has_many :related_photos

  has_many :pages
  has_many :albums
  has_one :theme

  scope :latest, :order_by => [:updated_at, :desc]
  scope :active_or_system, :where => {:status.in => %w(active system)}
  scope :active, :where => {:status => %w(active)}
  after_create :create_default_pages

  def validate
    # check if any other website with the same domain exists
    # errors.add(:domains)
  end

  STATUSES = %w(inactive active system deleted)
  STATUSES.each do |s|
    define_method("#{s}?".to_sym) { status == s}
    scope s.to_sym, :where => {:status => s}
  end

  def theme
    attributes[:theme] || Theme.new(:directory => :default)
  end

  def url
    'http://' + self.domain
  end

  def create_default_pages
    return if self.system?
    [self.pages.new(:title => 'Home', :body => 'Welcome to the photo portfolio of %s' % self.site_title),
    self.pages.new(:title => 'About', :body => 'Want to know more about %s?' % self.site_title),
    self.pages.new(:title => 'Contact', :body => 'The contact details of %s are yet missing.' % self.site_title)].each do |page|
      page.user = self.users.first # still could be nil
      page.save!
    end
    self.root_path = '/pages/' + self.pages.first.permalink
  end
end
