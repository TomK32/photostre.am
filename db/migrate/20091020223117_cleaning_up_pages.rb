class CleaningUpPages < ActiveRecord::Migration
  def self.up
    remove_column :pages, :meta_description
  end

  def self.down
  end
end
