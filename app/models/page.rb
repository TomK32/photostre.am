class Page < ActiveRecord::Base
  attr_accessible :title, :body, :excerpt, :permalink, :tags, :position, :parent_id, :state
  attr_accessible :meta_geourl, :meta_keywords, :meta_description

  acts_as_category :hidden => false
  has_permalink :title, :scope => :website_id
  belongs_to :website
  belongs_to :user
  alias_attribute :meta_description, :excerpt

  include AASM
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :published
  aasm_state :deleted

  validates_presence_of :title, :body, :body_html, :permalink
  validates_presence_of :website_id, :user_id

  before_validation :denormalize_body_and_excerpt
  
  def denormalize_body_and_excerpt
    self.body_html = textilize(self.body)
    self.excerpt_html = textilize(self.excerpt)
  end

end
