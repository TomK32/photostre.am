ActionController::Routing::Routes.draw do |map|
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.

  map.resources :photos
  map.resources :sources
  map.resources :users
  map.resources :sessions
  map.logout 'logout', :controller => "sessions", :action => "delete"
  map.login 'login', :controller => "sessions", :action => "new"

  map.connect 'dashboard', :controller => 'dashboard'

  map.root :controller => 'photos'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
