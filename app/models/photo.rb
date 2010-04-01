# TOOD
# * machine_tags
# * license
# * geo
class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

#  belongs_to :source
#  belongs_to :user
#  has_and_belongs_to_many :websites
#  has_and_belongs_to_many :albums

  scope :ordered, :order_by => 'created_at DESC, id DESC'
  scope :published, :where => {:public => true}
  scope :recent, :order_by => 'id DESC'
  scope :search, lambda {|term| {:where => 'title LIKE "%%%s%%" OR description LIKE "%%%s%%"' % [term, term] }}

  validates_uniqueness_of :remote_id, :scope => :source_id
  validates_presence_of :permalink
  validates_presence_of :source_id
  validates_presence_of :web_url
  validates_presence_of :photo_urls

  def photo_url(size = :medium, default_file = 'default.png')
    photo_urls[size.to_s] || photo_urls.values.first || default_file
  end

#  def photo_url(size = :medium)
#    self.photo_urls[size] || self.remote_photo_urls[0]
#  end

  def validate
    errors.add('username or user_id missing') if user_id.blank? and username.blank?
  end

  alias_attribute :meta_keywords, :tags

end
