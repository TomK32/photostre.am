# TOOD
# * machine_tags
# * license
# * geo
class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

#  belongs_to_related :source
  belongs_to_related :user

#TODO fields
  field :photo_urls, :type => Hash
  field :title, :type => String
  field :source_id, :type => String

  scope :ordered, :order_by => 'created_at DESC, id DESC'
  scope :published, :where => {:public => true}
  scope :recent, :order_by => 'id DESC'
  scope :search, lambda {|term| {:where => 'title LIKE "%%%s%%" OR description LIKE "%%%s%%"' % [term, term] }}

  validates_uniqueness_of :remote_id, :scope => :source_id
  validates_presence_of :source_id
  validates_presence_of :web_url
  validates_presence_of :photo_urls

  def source(args)
    self.user.sources.find source_id
  end


  def photo_url(size = :medium, default_file = 'default.png')
    photo_urls[size.to_s] || photo_urls.values.first || default_file
  end

  def validate
    errors.add('username or user_id missing') if user_id.blank? and username.blank?
  end
  def tag_list=(new_tags)
    self.tags = new_tags.to_s.split(/, /).uniq
  end
  def tag_list
    [self.tags].flatten.join(', ')
  end

  alias_attribute :meta_keywords, :tags

end
