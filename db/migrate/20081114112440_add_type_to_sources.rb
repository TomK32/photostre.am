class AddTypeToSources < ActiveRecord::Migration
  def self.up
    add_column :sources, :type, :string, :null => false, :default => 'Source'
    add_index :sources, :type
  end

  def self.down
    remove_index :sources, :type
    remove_column :sources, :type
  end
end
