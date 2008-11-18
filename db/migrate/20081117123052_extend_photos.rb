class ExtendPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :remote_id, :string
    add_index :photos, [:remote_id, :source_id], :unique => true
    add_index :photos, :title
    add_index :photos, :description
  end

  def self.down
    remove_index :photos, :column => :description
    remove_index :photos, :column => :title
    remove_index :photos, :column => [:remote_i, :column_name]
    remove_column :photos, :remote_id
  end
end
