# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_das-photowall_session',
  :secret      => 'b5d1de59ed49306b5cbc4135c36123ecf0e7c1a830522751861b209eb2b02364abf5ad38c2856017b6d1add50bcd28cca2ec5d795edc4407fed71be45fd03327'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
