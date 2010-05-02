DasPhotowall::Application.routes.draw do |map|

  resources :albums do
    resources :photos
  end
  
  resources :pages
  resources :photos
  resource :session
  

  namespace :admin do
    resources :sources do
      member do
        get :reauthenticate
      end
      collection do
        get :authenticate_flickr_account
      end
    end
    resources :websites do
      resources :pages do
        resources :related_photos
      end
      resources :albums do
        resources :related_photos
      end
      resources :related_photos
    end
    resources :related_photos
    resources :photos
    resources :users
  end
  
  get 'static/:action', :to => 'static', :as => 'static'
  get 'faq/:action', :to => 'static', :as => 'faq'

  get 'dashboard', :to => 'admin/dashboard#index'
  get 'login', :to => 'sessions#new'
  get 'logout', :to => 'sessions#delete'
  root :to => 'static#index'
end
