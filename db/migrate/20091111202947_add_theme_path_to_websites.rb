class AddThemePathToWebsites < ActiveRecord::Migration
  def self.up
    add_column :websites, :theme_path, :string, :default => 'default'
  end

  def self.down
    remove_column :websites, :theme_path
  end
end
