class AddOpenIdAuthenticationTables < ActiveRecord::Migration
  def self.up
    create_table :open_id_authentication_associations, :force => true do |t|
      t.integer :issued, :lifetime
      t.string :handle, :assoc_type
      t.binary :server_url, :secret
      
    end
    add_index :open_id_authentication_associations, :handle

    create_table :open_id_authentication_nonces, :force => true do |t|
      t.integer :timestamp, :null => false
      t.string :server_url, :null => true
      t.string :salt, :null => false
    end
  end

  def self.down
    remove_index :open_id_authentication_associations, :column => [:handle, :user_id]
    remove_index :open_id_authentication_associations, :handle
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
  end
end
