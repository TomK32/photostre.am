class CreatePhotosWebsites < ActiveRecord::Migration
  def self.up
    create_table :photos_websites, :id => false, :force => true do |t|
      t.references :photo, :null => false
      t.references :website, :null => false
    end
    add_index :photos_websites, :website_id
  end

  def self.down
    drop_table :photos_websites
  end
end
