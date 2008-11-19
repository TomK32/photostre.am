class Album < ActiveRecord::Base
  acts_as_tree :order => :position
  acts_as_list :scope => :parent_id
end
