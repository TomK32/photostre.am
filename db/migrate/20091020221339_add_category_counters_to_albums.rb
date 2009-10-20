class AddCategoryCountersToAlbums < ActiveRecord::Migration
  def self.up
    add_column :albums, :children_count,    :integer, :default => 0
  end

  def self.down
    remove_column :albums, :children_count
  end
end
