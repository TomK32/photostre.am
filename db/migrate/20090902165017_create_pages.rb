class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages, :force => true do |t|
      t.references :website
      t.references :user

      t.column :title,     :string, :null => false
      t.column :body,      :text,   :null => false
      t.column :body_html, :text,   :null => false

      t.column :excerpt,      :text
      t.column :excerpt_html, :text

      t.column :permalink, :string, :null => false
      t.column :tags, :text

      t.column :state, :string, :null => false, :default => 'published'

      t.column :position, :integer, :default => 0
      t.column :version,  :integer, :default => 0

      t.string  :meta_geourl
      t.string  :meta_keywords
      t.text    :meta_description

      t.references :parent
      t.column :descendants_count, :integer, :default => 0
      t.column :ancestors_count,   :integer, :default => 0
      t.column :children_count,    :integer, :default => 0
      
    end
    add_index :pages, :state
    add_index :pages, :permalink
  end

  def self.down
    drop_table :pages
  end
end
