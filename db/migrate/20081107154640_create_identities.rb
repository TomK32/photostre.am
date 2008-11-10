class CreateIdentities < ActiveRecord::Migration
  def self.up
    create_table :identities do |t|
      t.column :identity_url, :string, :null => false, :unique => true
      t.column :user_id, :integer
      t.timestamps
    end
    add_index :identities, :identity_url, :unique => true
  end

  def self.down
    remove_index :identity_url, :identity_url
    drop_table :identities
  end
end
