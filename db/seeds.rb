# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Website.create!(:site_title => 'photostre.am', :domain => 'photostre.am', :state => 'system')
admin = User.first || User.create!(:login => 'admin')
Theme.create!(:name => 'Alboom', :directory => 'alboom', :author => admin, :status => 'public',
  :description => 'Minimalistic white theme.')
Theme.create!(:name => 'Blick', :directory => 'blick', :author => admin, :status => 'public',
  :description => 'Vintage green with dark blue headers and links in a minimalistic design.')
Theme.create!(:name => 'Grash', :directory => 'grash', :author => admin, :status => 'public',
  :description => 'Futuristic grey and blue nightmare.')