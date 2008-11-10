class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.column :source_id, :integer, :null => false
      t.column :title, :string
      t.column :description, :string
      t.column :web_url, :string, :null => false
      t.column :photo_url, :string, :null => false
      t.column :thumbnail_url, :string, :null => false
      t.column :username, :string
      t.column :user_id, :integer
      t.column :public, :boolean, :default => true
      t.column :permalink, :string, :unique => true
      
      t.timestamps
    end
    add_index :photos, :permalink, :unique => true
    
  end

  def self.down
    drop_table :photos_websites
    remove_index :photos, :permalink
    drop_table :photos
  end
end
