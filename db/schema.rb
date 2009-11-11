# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091111202947) do

  create_table "albums", :force => true do |t|
    t.string   "title",                                            :null => false
    t.string   "permalink",                                        :null => false
    t.integer  "position",                :default => 0,           :null => false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body"
    t.text     "body_html"
    t.integer  "website_id"
    t.string   "state",                   :default => "published"
    t.integer  "ancestors_count",         :default => 0
    t.integer  "descendants_count",       :default => 0
    t.integer  "key_photo_id"
    t.string   "key_photo_thumbnail_url"
    t.string   "key_photo_medium_url"
    t.integer  "children_count",          :default => 0
  end

  create_table "albums_photos", :id => false, :force => true do |t|
    t.integer "album_id", :null => false
    t.integer "photo_id", :null => false
  end

  add_index "albums_photos", ["album_id"], :name => "index_albums_photos_on_album_id"

  create_table "identities", :force => true do |t|
    t.string   "identity_url", :null => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["identity_url"], :name => "index_identities_on_identity_url", :unique => true

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
    t.integer "user_id"
  end

  add_index "open_id_authentication_associations", ["handle", "user_id"], :name => "index_open_id_authentication_associations_on_handle_and_user_id", :unique => true
  add_index "open_id_authentication_associations", ["handle"], :name => "index_open_id_authentication_associations_on_handle"

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "pages", :force => true do |t|
    t.integer "website_id"
    t.integer "user_id"
    t.string  "title",                                      :null => false
    t.text    "body",                                       :null => false
    t.text    "body_html",                                  :null => false
    t.text    "excerpt"
    t.text    "excerpt_html"
    t.string  "permalink",                                  :null => false
    t.text    "tags"
    t.string  "state",             :default => "published", :null => false
    t.integer "position",          :default => 0
    t.integer "version",           :default => 0
    t.string  "meta_geourl"
    t.string  "meta_keywords"
    t.integer "parent_id"
    t.integer "descendants_count", :default => 0
    t.integer "ancestors_count",   :default => 0
    t.integer "children_count",    :default => 0
  end

  add_index "pages", ["permalink"], :name => "index_pages_on_permalink"
  add_index "pages", ["state"], :name => "index_pages_on_state"

  create_table "photos", :force => true do |t|
    t.integer  "source_id",                       :null => false
    t.string   "title"
    t.string   "description"
    t.string   "web_url",                         :null => false
    t.string   "photo_url",                       :null => false
    t.string   "thumbnail_url",                   :null => false
    t.string   "username"
    t.integer  "user_id"
    t.boolean  "public",        :default => true
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remote_id"
    t.datetime "taken_at"
    t.datetime "uploaded_at"
    t.string   "icon_url"
    t.string   "medium_url"
  end

  add_index "photos", ["description"], :name => "index_photos_on_description"
  add_index "photos", ["permalink"], :name => "index_photos_on_permalink", :unique => true
  add_index "photos", ["remote_id", "source_id"], :name => "index_photos_on_remote_id_and_source_id", :unique => true
  add_index "photos", ["title"], :name => "index_photos_on_title"

  create_table "photos_websites", :id => false, :force => true do |t|
    t.integer "photo_id",   :null => false
    t.integer "website_id", :null => false
  end

  add_index "photos_websites", ["website_id"], :name => "index_photos_websites_on_website_id"

  create_table "sources", :force => true do |t|
    t.string   "feed_url"
    t.string   "username"
    t.string   "api_key"
    t.string   "secret"
    t.string   "token"
    t.string   "title"
    t.integer  "user_id"
    t.boolean  "active",           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "flickr_nsid"
    t.datetime "authenticated_at"
    t.datetime "last_updated_at"
    t.string   "type",             :default => "Source", :null => false
    t.string   "state",            :default => "active"
  end

  add_index "sources", ["type"], :name => "index_sources_on_type"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "themes", :force => true do |t|
    t.string  "name",                                           :null => false
    t.string  "directory",                                      :null => false
    t.text    "description",                                    :null => false
    t.integer "version"
    t.integer "author_id",                                      :null => false
    t.integer "user_id",                                        :null => false
    t.string  "license",     :default => "All rights reserved"
    t.string  "state",       :default => "private",             :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",      :limit => 40,                         :null => false
    t.string   "name",       :limit => 100, :default => ""
    t.string   "email",      :limit => 100
    t.string   "state",                     :default => "passive"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "users_websites", :id => false, :force => true do |t|
    t.integer  "website_id", :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_websites", ["website_id", "user_id"], :name => "index_users_websites_on_website_id_and_user_id", :unique => true

  create_table "websites", :force => true do |t|
    t.string   "domain"
    t.string   "site_title"
    t.string   "meta_keywords"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",         :default => "active"
    t.string   "root_path"
    t.string   "theme",         :default => "default", :null => false
    t.text     "tracking_code"
    t.string   "theme_path",    :default => "default"
  end

  add_index "websites", ["domain"], :name => "index_websites_on_domain", :unique => true

end
