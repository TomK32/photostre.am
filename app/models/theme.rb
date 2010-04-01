class Theme
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to_related :user
  field :name, :type => String
  field :directory, :type => String

  validates_uniqueness_of :directory

  STATUSES = %w(draft deleted public private paid)

end
