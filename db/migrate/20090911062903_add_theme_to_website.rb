class AddThemeToWebsite < ActiveRecord::Migration
  def self.up
    add_column :websites, :theme, :string, :null => false, :default => 'default'
  end

  def self.down
    remove_column :websites, :theme
  end
end
