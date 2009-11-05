class RemoveWebsiteIdFromSources < ActiveRecord::Migration
  def self.up
    remove_column :sources, :website_id
  end

  def self.down
    add_column :sources, :website_id, :integer, :null => false
  end
end
