# TOOD
# * machine_tags
# * license
# * geo
class Photo < ActiveRecord::Base
  belongs_to :source
  belongs_to :user
  
  named_scope :published, :conditions => {:public => true}
  named_scope :recent, :order => 'id DESC'
  
  is_taggable :tags, :machine_tags
  has_permalink :title

  cattr_reader :per_page
  @@per_page = 10
  
  validates_uniqueness_of :remote_id, :scope => :source_id
  
  def validate
    errors.add('username or user_id missing') if user_id.blank? and username.blank?
  end

end
