ActionController::Routing::Routes.draw do |map|

  map.resources :photos
  map.resources :sources, :member => {:reauthenticate => :get}, :collection => {:authenticate_flickr_account => :get}
  map.resources :users
  map.resources :websites
  map.resources :sessions
  map.logout 'logout', :controller => "sessions", :action => "delete"
  map.login 'login', :controller => "sessions", :action => "new"

  map.dashboard 'dashboard', :controller => 'dashboard'

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
