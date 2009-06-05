class Album < ActiveRecord::Base
  acts_as_tree :order => :position
  acts_as_list :scope => :parent_id
  
  named_scope :public, :conditions => {:state => 'public'}
  named_scope :latest, :order => 'updated_at DESC'
  
end
