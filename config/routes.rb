ActionController::Routing::Routes.draw do |map|

  map.resources :albums do |album|
    album.resources :photos
  end
  map.resources :pages
  map.resources :photos
  map.resources :users

  map.namespace :admin do |admin|
    admin.resources :albums
    admin.resources :photos
    admin.resources :sources, :member => {:reauthenticate => :get}, :collection => {:authenticate_flickr_account => :get}
    admin.resources :themes
    admin.resources :websites do |website|
      website.resources :albums
      website.resources :pages
      website.resources :photos
    end
  end
  map.resources :sessions
  map.with_options :controller => "sessions" do |sessions|
    sessions.logout 'logout', :action => "delete"
    sessions.login 'login', :action => "new"
  end

  map.with_options :controller => 'admin/dashboard' do |dashboard|
    dashboard.connect '/admin'
    dashboard.dashboard '/dashboard'
  end

  map.connect ':file_type/theme/*filename', :controller => 'theme_files', :action => "show"

  map.static ':action', :controller => 'static'
  map.faq 'faq/:action', :controller => 'static'

  map.root :controller => 'static', :action => 'index'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
