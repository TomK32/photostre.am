class Website < ActiveRecord::Base
  validates_presence_of :domain
  validates_uniqueness_of :domain
  has_and_belongs_to_many :users
  has_many :sources
  
  named_scope :active, :conditions => {:state => 'active'}
  named_scope :latest, :order => 'updated_at DESC'

end
