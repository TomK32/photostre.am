class AddKeyPhotoToAlbum < ActiveRecord::Migration
  def self.up
    add_column :albums, :key_photo_id, :integer
    add_column :albums, :key_photo_thumbnail_url, :string
    add_column :albums, :key_photo_medium_url, :string
  end

  def self.down
    remove_column :albums, :key_photo_medium_url
    remove_column :albums, :key_photo_thumbnail_url
    remove_column :albums, :key_photo_id
  end
end
