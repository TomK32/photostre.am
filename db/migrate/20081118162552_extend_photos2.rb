class ExtendPhotos2 < ActiveRecord::Migration
  def self.up
    add_column :photos, :taken_at, :datetime
    add_column :photos, :uploaded_at, :datetime
  end

  def self.down
    remove_column :photos, :uploaded_at
    remove_column :photos, :taken_at
  end
end
