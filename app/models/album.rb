class Album < ActiveRecord::Base
  acts_as_category
  
  named_scope :published, :conditions => {:state => 'published'}
  named_scope :latest, :order => 'updated_at DESC'
  
  has_permalink :title, :scope => :website_id
  belongs_to :website
  has_and_belongs_to_many :photos
  validates_presence_of :website_id, :title
  
  include AASM
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :published
  aasm_state :deleted
  

  before_validation :denormalize_body
  
  def denormalize_body
    self.body_html = textilize(self.body)
  end

end
