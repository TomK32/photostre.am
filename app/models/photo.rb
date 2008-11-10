class Photo < ActiveRecord::Base
  belongs_to :source
  belongs_to :user
  
  named_scope :active
  
  def validate
    errors.add('username or user_id missing') if user_id.blank? and username.blank?
  end

end
