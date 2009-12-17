class AddThemeIdToWebsites < ActiveRecord::Migration
  def self.up
    add_column :websites, :theme_id, :integer
    add_index :websites, :theme_id
    remove_column :websites, :theme
  end

  def self.down
    remove_index :websites, :theme_id
    remove_column :websites, :theme_id
    add_column :websites, :theme, :string, :null => false, :default => 'default'
  end
end
