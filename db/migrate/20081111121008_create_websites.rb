class CreateWebsites < ActiveRecord::Migration
  def self.up
    create_table :websites do |t|
      t.column :domain, :string, :null => false, :default => 'localhost', :unique => true
      t.column :site_title, :string
      t.column :metatags, :string
      t.column :footer_line, :string
      t.column :description, :string
      t.column :active, :boolean, :default => true

      t.timestamps
    end
    add_index :websites, :domain, :unique => true

    Website.create!(:site_title => 'das-photowall', :metatags => 'photos, log',
      :footer_line => '&copy; 2008 by das-photowall')

    create_table :users_websites, :id => false do |t|
      t.column :website_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.timestamps
    end
    add_index :users_websites, [:website_id, :user_id], :unique => true
  end

  def self.down
    remove_index :websites, :column => :domain
    remove_index :users_websites, :column => [:website_id, :user_id]
    drop_table :users_websites
    drop_table :websites
  end
end
