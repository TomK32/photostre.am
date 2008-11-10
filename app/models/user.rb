class User < ActiveRecord::Base
  has_many :photos
  has_many :sources
  has_many :identities
  
  validates_presence_of :email, :login
  
  
  def to_param
    [id, login] * '-'
  end
  
end
