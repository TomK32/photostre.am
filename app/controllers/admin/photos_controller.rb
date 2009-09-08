class Admin::PhotosController < Admin::ApplicationController
  
  make_resourceful do
    actions :all
    belongs_to :current_user
    
  end
end
