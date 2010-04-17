class Source
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, :type => String, :default => 'active'
  field :title, :type => String
  field :username, :type => String
  field :authenticated_at, :type => DateTime
  field :last_updated_at, :type => DateTime
  field :is_pro

  has_many_related :photos
  embedded_in :user, :inverse_of => :sources
#  index [:username, :_type], :unique => true

  ACTIVE_TYPES = AVAILABLE_TYPES = [['Flickr.com', 'Source::FlickrAccount']]
  STATUSES = %w(inactive active deleted updating)

#  validates_presence_of :title
#  validates_length_of :title, :minimum => 3

  scope :recent, :order_by => 'last_updated_at DESC'
  scope :active, :where => {:status => 'active'}

  def call_worker
    false # implement yourself goddamn it
  end

  def source_type=(source_type)
    self.attributes[:_type] = source_type if AVAILABLE_TYPES.collect{|t|t[0]}.include?(source_type)
  end

  def source_type
    self.attributes[:_type].to_s
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
