class Website < ActiveRecord::Base
  validates_presence_of :domain, :site_title, :state
  validates_uniqueness_of :domain
  has_and_belongs_to_many :users
  has_many :sources
  has_many :pages
  has_many :albums
  has_and_belongs_to_many :photos
  belongs_to :theme

  named_scope :latest, :order => 'updated_at DESC'
  named_scope :active_or_system, :conditions => {:state => ['active', 'system']}
  after_create :create_default_pages
  before_save :set_theme_path

  include AASM
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :active
  aasm_state :system
  aasm_state :deleted

  def url
    'http://' + self.domain
  end

  def set_theme_path
    if theme
      self.theme_path = theme.directory
    else
      self.theme_path = 'default'
    end
  end

  def create_default_pages
    [self.pages.new(:title => 'Home', :body => 'Welcome to the photo portfolio of %s' % self.site_title), 
    self.pages.new(:title => 'About', :body => 'Want to know more about %s?' % self.site_title),
    self.pages.new(:title => 'Contact', :body => 'The contact details of %s are yet missing.' % self.site_title)].each do |page|
      page.user = self.users.first # still could be nil
      page.save
    end
    self.root_path = '/pages/' + self.pages.first.permalink
  end
end
