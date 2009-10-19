class AddTakenAtToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :taken_at, :datetime, :null => false, :default => Time.now
    add_index :photos, :taken_at
  end

  def self.down
    remove_column :photos, :taken_at
    remove_index :photos, :taken_at, :datetime
  end
end
