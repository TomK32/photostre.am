# TOOD
# * machine_tags
# * license
# * geo
class Photo < ActiveRecord::Base
  belongs_to :source
  belongs_to :user
  has_and_belongs_to_many :websites
  
  named_scope :published, :conditions => {:public => true}
  named_scope :recent, :order => 'id DESC'
  
  acts_as_taggable_on :tags, :machine_tags
  has_permalink :title

  cattr_reader :per_page
  @@per_page = 10
  
  validates_uniqueness_of :remote_id, :scope => :source_id
  validates_presence_of :permalink
  validates_presence_of :source_id
  validates_presence_of :web_url
  validates_presence_of :photo_url
  
  
  def validate
    errors.add('username or user_id missing') if user_id.blank? and username.blank?
  end

end
