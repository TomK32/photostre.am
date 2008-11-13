class AddFlickrNsidToSource < ActiveRecord::Migration
  def self.up
    add_column :sources, :flickr_nsid, :string
  end

  def self.down
    remove_column :sources, :flickr_nsid
  end
end
