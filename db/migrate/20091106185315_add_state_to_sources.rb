class AddStateToSources < ActiveRecord::Migration
  def self.up
    add_column :sources, :state, :string, :default => 'active'
    remove_column :sources, :active
  end

  def self.down
    add_column :sources, :active, :boolean,           :default => true
    remove_column :sources, :state
  end
end
