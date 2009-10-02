class CreateTableAlbumsPhotos < ActiveRecord::Migration
  def self.up
    create_table :albums_photos, :force => true, :id => false do |t|
      t.references :album, :null => false
      t.references :photo, :null => false
    end
    add_index :albums_photos, :album_id
  end

  def self.down
    drop_table :albums_photos
  end
end
