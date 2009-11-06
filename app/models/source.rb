class Source < ActiveRecord::Base
  has_many :photos
  belongs_to :user
  belongs_to :website

  ACTIVE_TYPES = AVAILABLE_TYPES = [['Flickr.com', 'Source::FlickrAccount']]

  include AASM
  aasm_column :state
  aasm_initial_state :active
  aasm_state :active
  aasm_state :updating
  aasm_state :deleted


  validates_presence_of :type
  validates_presence_of :user_id

  validates_presence_of :title
  validates_length_of :title, :minimum => 3
  validates_uniqueness_of :username, :scope => 'type'

  named_scope :active, :conditions => {:active => true }
  named_scope :recent, :order => 'last_updated_at DESC'

  def source_type=(source_type)
    self[:type] = source_type if AVAILABLE_TYPES.collect{|t|t[0]}.include?(source_type)
  end

  def source_type
    self[:type].to_s
  end
  def source_title
    AVAILABLE_TYPES.each do |source_t|
      return source_t[0] if source_t[1] = source_type
    end
  end
  def authenticated?
    ! authenticated_at.blank?
  end

  def photostream_url; end
  def profile_url; end
end
