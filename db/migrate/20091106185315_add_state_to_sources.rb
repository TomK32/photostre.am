class AddStateToSources < ActiveRecord::Migration
  def self.up
    add_column :sources, :state, :string, :default => 'active'
  end

  def self.down
    remove_column :sources, :state
  end
end
