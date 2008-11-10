class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.column :feed_url, :string
      t.column :username, :string
      t.column :api_key, :string
      t.column :secret, :string
      t.column :token, :string
      t.column :title, :string, :null => false
      t.column :user_id, :integer, :null => false
      t.column :website_id, :integer, :null => false
      t.column :active, :boolean, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
