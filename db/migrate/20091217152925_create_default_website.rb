class CreateDefaultWebsite < ActiveRecord::Migration
  def self.up
    Theme.default.delete if Theme.default
    Theme.create :name => 'default',
                 :directory => 'default',
                 :description => 'Default Theme',
                 :state => 'public',
                 :author_id => 1,
                 :user_id => 1
  end

  def self.down
    Theme.default.delete if Theme.default
  end
end
