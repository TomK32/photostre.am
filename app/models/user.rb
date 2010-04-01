class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, :type => String

  has_many_related :photos
  has_many :sources
  has_many :identities
  # has_and_belongs_to_many :websites

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

  def to_param
    [id, login] * '-'
  end

end
