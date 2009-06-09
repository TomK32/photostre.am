class RemoveSomeThingsFromWebsites < ActiveRecord::Migration
  def self.up
    change_column :websites, :domain, :string, :null => true, :default => nil
    remove_column :websites, :footer_line
  end

  def self.down
    add_column :websites, :footer_line, :string
    change_column :websites, :domain, :string, :null => false, :default => 'localhost'
  end
end
