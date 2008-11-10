class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login, :string, :limit => 40, :null => false
      t.column :name, :string, :limit => 100, :default => ''
      t.column :email, :string, :limit => 100
      t.column :state, :string, :null => :false, :default => 'passive'
      t.column :deleted_at, :datetime      
      t.timestamps
    end
    
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table :users
  end
end
