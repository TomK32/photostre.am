# The basic idea is that we take the existing data via ActiveRecord
# and create new documents in MongoDB using MongoMapper.
# This method is necessary as we want to keep all the associations of existing dataset
# and by the way, clean up empty columns
# We rely on models still being ActiveRecord::Base, I bet you can figure out how the look like.
# And have the newer MongoDB ones here in a module, painful as we have to set the collection_name
# Don't put a +timestamps!+ into your MongoMapper models yet because this would change the updated_at if existing
# As you see in the MongoDB models, a few loose their indepence, e.g. Source as I
# plan to add other sources besides flickr, or Page and Album which only make sense in
# their parent Website
# Photo stays independed though I'm thinking about making copies into Album and Page
# as this would allow the user to change e.g. title or tags in his photos

require 'rubygems'
require 'mongo'
require 'mongoid'

# MongoStream is just some namespace
module MongoStream
  # own collection
  class Photo
    include Mongoid::Document
    self.collection_name = 'photos'
    field :tags, :type => Array
    field :photo_urls, :type => Array
    belongs_to_related :source, :class_name => "MongoStream::Source", :foreign_key => "source_id"
  end
  # part of User
  class Source
    include Mongoid::Document
    belongs_to :user, :inverse_of => :sources
  end
  # part of Website
  class Album
    include Mongoid::Document
    field :photo_ids, :type => Array
    belongs_to :website, :inverse_of => :albums
  end
  # part of Website
  class Page
    include Mongoid::Document
    field :tags, :type => Array
    belongs_to :website, :inverse_of => :pages
  end
  # own collection
  class User
    include Mongoid::Document
    self.collection_name = 'users'
    field :source_ids, :type => Array
    has_many :sources, :class_name => "MongoStream::Source"
    has_many :photos,  :class_name => "MongoStream::Photo"
    # has_and_belongs_to_many :websites
  end
  # own collection
  class Website
    include Mongoid::Document
    self.collection_name = 'websites'
    field :user_ids,  :type => Array
    field :photo_ids, :type => Array
    has_many :albums, :class_name => "MongoStream::Album"
    has_many :pages,  :class_name => "MongoStream::Page"
  end
end

class MigrateToMongodb < ActiveRecord::Migration
  def self.clean_attrs(object, unneeded_attributes = [])
    unneeded_attributes << 'id'
    attributes = object.attributes.dup
    # we keep the old_id for now to copy the associations much easier
    attributes['old_id'] = attributes['id']
    attributes.reject!{|k,v|unneeded_attributes.include?(k.to_s) || v.nil?}
    attributes['status'] = attributes['state']
    attributes.delete('status')
    attributes
  end
  def self.up
    # first remove all existing data in the collections
    %w(MongoStream::User MongoStream::Website MongoStream::Photo).map{|klass| instance_eval("#{klass}.delete_all") rescue nil }
    ::User.all.each do |user|
      m_user = MongoStream::User.create!(clean_attrs(user))

      user.sources.all.each do |source|
        m_source = MongoStream::Source.new(clean_attrs(source, %w(user_id)))
        source.photos.all.each do |photo|
          m_photo = MongoStream::Photo.create!(clean_attrs(photo, %w(photo_url icon_url thumbnail_url medium_url)))
          m_photo.photo_urls = {:original => photo.photo_url, :icon => photo.icon_url,  
            :thumbnail => photo.thumbnail_url, :medium => photo.medium_url}
          m_photo.tags = photo.tag_list.to_a
          m_photo.source_id = m_source.id
          m_photo.user_id = m_user.id # redundant but that's ok I think
          m_photo.save
        end
        m_user.sources << m_source
      end
      # With all those embedded documents, never forget to save the root element!
      m_user.save
    end
    
    ::Website.all.each do |website|
      m_website = MongoStream::Website.create!(clean_attrs(website))
      m_website.photo_ids = MongoStream::Photo.all(:conditions => {:old_id => website.photo_ids}).collect(&:id)
      m_website.user_ids = MongoStream::User.all(:conditions => {:old_id => website.user_ids}).collect(&:id)
      
      website.albums.each do |album|
        m_album = MongoStream::Album.new(clean_attrs(album, %w(website_id parent_id)))
        m_album.key_photo_id = MongoStream::Photo.first(:conditions => {:old_id => album.key_photo_id}).id
        m_album.photo_ids = MongoStream::Photo.all(:conditions => {:old_id => album.key_photo_id}).collect(&:id)
        m_website.albums << m_album
      end

      website.pages.each do |page|
        m_page = MongoStream::Page.new(clean_attrs(page, %w(website_id user_id parent_id)))
        m_page.tags = page.tag_list.to_a
        m_website.pages << m_page
      end
      m_website.save
    end

    # The best is to clean up and remove the old_ids via the mongo console, there for mongo 1.3+
    #   db.photos.update({}, { $unset : { old_id : 1}}, false, true )
    #   db.websites.update({}, { $unset : { old_id : 1, 'albums.old_id': 1, 'pages.old_id': 1}}, false, true )
    #   db.users.update({}, { $unset : { old_id : 1}}, false, true )
    
  end

  def self.down
  end
end
