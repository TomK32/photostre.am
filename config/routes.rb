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

  map.static ':action', :controller => 'static'
  map.faq 'faq/:action', :controller => 'static'

  map.root :controller => 'static', :action => 'index'
end
