class ExtendAlbums < ActiveRecord::Migration
  def self.up
    add_column :albums, :body, :text
    add_column :albums, :body_html, :text
    add_column :albums, :website_id, :integer, :nil => false
    add_column :albums, :state, :string, :default => 'published'
    add_column :albums, :ancestors_count, :integer, :default => 0
    add_column :albums, :descendants_count, :integer, :default => 0
    remove_column :albums, :published, :null => false, :default => 'published'
  end

  def self.down
    remove_column :albums, :descendants_count
    remove_column :albums, :ancestors_count
    add_column :albums, :published, :boolean, :default => 'published', :null => false
    remove_column :albums, :state
    remove_column :albums, :website_id
    remove_column :albums, :body
    remove_column :albums, :body_html
  end
end
