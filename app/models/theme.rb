class Theme
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to_related :user
  field :name, :type => String, :required => true
  field :directory, :type => String, :required => true
  field :description, :type => String
  field :license, :type => String
  field :status, :type => String, :default => 'private'
  field :version, :type => String

  belongs_to_related :author, :class_name => 'User'
  validates_uniqueness_of :directory
  validates_presence_of :author_id, :name, :directory

  STATUSES = %w(draft deleted public private paid)
  STATUSES.each do |s|
    define_method("#{s}?".to_sym) { status == s}
    scope s.to_sym, :where => {:status => s}
  end
  

end
