class CreateThemes < ActiveRecord::Migration
  def self.up
    create_table :themes, :force => true do |t|
      t.column :name, :string, :null => false
      t.column :directory, :string, :null => false
      t.column :description, :text, :null => false
      # acts_as_versioned
      t.column :version, :integer
      # who wrote it
      t.column :author_id, :integer, :null => false
      # who edited it last
      t.column :user_id, :integer, :null => false
      t.column :license, :string, :default => 'All rights reserved'
      t.column :state, :string, :null => false, :default => 'private'
    end
  end

  def self.down
    drop_table :themes
  end
end
