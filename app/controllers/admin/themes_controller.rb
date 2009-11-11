class Admin::ThemesController < Admin::ApplicationController
  make_resourceful do
    actions :all
  end
end
