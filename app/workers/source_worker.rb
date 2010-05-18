class SourceWorker
  def self.sync_website(options)
    website = Website.find(options[:id]).source_ids.each do |source_id|
      source = User.where({'sources._id' => source_id}).only('sources').first.sources.find(source_id)
      source.update_data
    end
    source.import_albums
  end
  def self.import_album(options)
    album = Website.where('albums._id' => options[:id]).albums.find(options[:id])
    album.import_remote
  end
end