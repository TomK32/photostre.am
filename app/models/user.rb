class User < ActiveRecord::Base
  has_many :photos
  has_many :sources
  has_many :identities
  has_and_belongs_to_many :websites

  validates_presence_of :email, :login
  
  validates_uniqueness_of :login
  
  acts_as_tagger
  
  def to_param
    [id, login] * '-'
  end
  
end
