class AddStateFields < ActiveRecord::Migration
  def self.up
    add_column :albums, :state, :string, :default => 'public'
    add_index :albums, :state
    remove_column :websites, :active
    add_column :websites, :state, :string, :default => 'active'
  end

  def self.down
    add_column :websites, :active, :boolean, :default => true
    remove_column :websites, :state
    remove_index :albums, :state
    remove_column :albums, :public
  end
end
