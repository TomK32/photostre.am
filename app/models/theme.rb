class Theme < ActiveRecord::Base
  belongs_to :user
  belongs_to :author, :class_name => "User", :foreign_key => 'author_id'
  has_many :websites

  validates_uniqueness_of :directory

  include AASM
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :deleted
  aasm_state :public
  aasm_state :private
  aasm_state :paid

  def self.default
    Theme.first(:conditions => { :directory => 'default' })
  end
end
