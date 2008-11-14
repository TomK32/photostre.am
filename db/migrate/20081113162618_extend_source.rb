class ExtendSource < ActiveRecord::Migration
  def self.up
    add_column :sources, :authenticated_at, :datetime
    add_column :sources, :last_updated_at, :datetime
  end

  def self.down
    remove_column :sources, :last_updated_at
    remove_column :sources, :authenticed_at
  end
end
