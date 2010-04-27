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
  field :description, :type => String
  field :source_id, :type => String
  field :remote_id, :type => String
  field :web_url, :type => String
  field :taken_at, :type => DateTime
  field :tags, :type => Array, :default => []
  field :public, :type => Boolean
  field :friends, :type => Boolean
  field :family, :type => Boolean

  index :title
  index :tags
  index :description

  scope :ordered, :order_by => 'created_at DESC, id DESC'
  scope :published, where({:public => true})
  scope :recent, :order_by => 'id DESC'

  validates_presence_of :source_id
  validates_presence_of :web_url
  validates_presence_of :photo_urls

  index [[:source_id], [:remote_id]], :unique => true

  def source
    @source ||= User.where(:_id => self.user_id).only(:sources).first.sources.find(self.source_id)
  end


  def photo_url(size = :m, default_file = 'default.png')
    available_sizes = {:original => :o, :small => :sm, :medium => :m, :thumbnail => :t, :square => :s, :big => :b}
    size = :medium if !available_sizes.keys.include?(size.to_sym)
    return photo_urls[available_sizes[size.to_sym].to_s] if photo_urls[available_sizes[size.to_sym].to_s]
    available_sizes[:small] = :m
    photo_urls['m'].gsub(/(\.(png|jpg|jpeg|gif))$/, '_' + available_sizes[size.to_sym].to_s + '\1')
  end

  def validate
    errors.add('username or user_id missing') if user_id.blank? and username.blank?
  end
  def tag_list=(new_tags)
    self.tags = new_tags.to_s.split(/[, ]/).uniq
  end
  def tag_list
    [self.tags].flatten.join(', ')
  end
  def machine_tag_list=(new_tags)
    self.tags = new_tags.to_s.split(/[, ]/).uniq
  end
  def machine_tag_list
    [self.tags].flatten.join(', ')
  end

  alias_attribute :meta_keywords, :tags

end
