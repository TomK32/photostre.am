class AddRootPathToWebsites < ActiveRecord::Migration
  def self.up
    add_column :websites, :root_path, :string
  end

  def self.down
    remove_column :websites, :root_path
  end
end
