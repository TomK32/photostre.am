class RenameWebsitesMetatags < ActiveRecord::Migration
  def self.up
    rename_column :websites, :metatags, :meta_keywords
  end

  def self.down
    rename_column :websites, :meta_keywords, :metatags
  end
end
