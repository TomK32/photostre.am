class Website < ActiveRecord::Base
  validates_presence_of :domain, :site_title
  validates_uniqueness_of :domain
  has_and_belongs_to_many :users
  has_many :sources
  has_many :pages
  has_many :albums
  has_and_belongs_to_many :photos

  named_scope :latest, :order => 'updated_at DESC'

  include AASM
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :active
  aasm_state :deleted

  def url
    'http://' + self.domain
  end
end
