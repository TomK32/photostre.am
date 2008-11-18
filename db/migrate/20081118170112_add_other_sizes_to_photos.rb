class AddOtherSizesToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :icon_url, :string
    add_column :photos, :medium_url, :string
  end

  def self.down
    remove_column :photos, :medium_url
    remove_column :photos, :icon_url
  end
end
