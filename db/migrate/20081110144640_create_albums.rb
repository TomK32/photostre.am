class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.column :title, :string, :null => false
      t.column :permalink, :string, :null => false
      t.column :published, :boolean, :default => true
      t.column :position, :integer, :default => 0, :null => false
      t.column :parent_id, :integer, :default => nil

      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
