class AddTrackingCodeToWebsites < ActiveRecord::Migration
  def self.up
    add_column :websites, :tracking_code, :text
  end

  def self.down
    remove_column :websites, :tracking_code
  end
end
