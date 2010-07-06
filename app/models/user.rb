class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,  :type => String
  field :email, :type => String
  field :login, :type => String
  field :roles, :type => Array

  has_many_related :photos
  has_many_related :themes
  embed_many :sources
  embed_many :identities
  # has_and_belongs_to_related_many :websites

  validates_presence_of :login

  validates_uniqueness_of :login

  def validate
    if !self.new_record?
      errors.add :email if email.blank?
    end
  end

  def websites
    Website.where({:user_ids => self.id })
  end

  def has_role?(role)
    self.roles.is_a?(Array) and self.roles.include?(role.to_s.capitalize)
  end

  def is_admin?
    self.has_role?(:admin)
  end
end
