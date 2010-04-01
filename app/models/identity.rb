class Identity
  include Mongoid::Document

  belongs_to :user, :inverse_of => :identities
  validates_presence_of :identity_url
end
