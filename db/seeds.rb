# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

admin = User.first || User.create!(:login => 'admin')
Website.create!(:site_title => 'photostre.am', :domain => 'photostre.am', :state => 'system', :user_ids => [admin.id])

Theme.create!(:name => '365shots.net' , :directory => 'system-365', :author => admin, :status => 'system')

Theme.create!(:name => 'Alboom', :directory => 'alboom', :author => admin, :status => 'public',
  :description => 'Minimalistic white theme.')
Theme.create!(:name => 'Blick', :directory => 'blick', :author => admin, :status => 'public',
  :description => 'Vintage green with dark blue headers and links in a minimalistic design.')
Theme.create!(:name => 'Grash', :directory => 'grash', :author => admin, :status => 'public',
  :description => 'Futuristic grey and blue nightmare.')
Theme.create!(:name => 'Bildlich' , :directory => 'bildlich', :author => User.where('sources.flickr_nsid' => '37704933@N03').first, :status => 'public', :description => 'Best with photos as homepage')
Theme.create!(:name => 'Digalog' , :directory => 'digalog', :author => User.where('sources.flickr_nsid' => '39052170@N06').first, :status => 'public')
