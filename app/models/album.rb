class Album < ActiveRecord::Base
  acts_as_tree :order => :position
  acts_as_list :scope => :parent_id
  
  named_scope :published, :conditions => {:state => 'published'}
  named_scope :latest, :order => 'updated_at DESC'
  
  include AASM
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :published
  aasm_state :deleted
  
end
