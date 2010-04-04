DasPhotowall::Application.routes.draw do |map|
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  resources :albums do
    resources :photos
  end
  
  resources :pages
  resources :photos
  resources :users
  

  namespace :admin do
    resources :sources do
      get :reauthenticate, :on => :memeber
      get :authenticate_flickr_account, :on => :collection
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
    resources :photos
  end
  get 'static/:action', :to => 'static'
  get 'faq/:action', :to => 'static'

  get 'dashboard', :to => 'dashboard#index'
  get 'login', :to => 'sessions#new'
  get 'logout', :to => 'sessions#delete'
  root :to => 'static#index'
end
