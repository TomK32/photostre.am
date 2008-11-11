class Website < ActiveRecord::Base
  validates_presence_of :domain
  has_and_belongs_to_many :users
  
  named_scope :active, :conditions => {:active => true }
end
