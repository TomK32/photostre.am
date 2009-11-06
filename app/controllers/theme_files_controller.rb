class ThemeFilesController < ApplicationController
  def show
    file_name = File.join(current_theme_path, 'public', params[:file_type], File.join(params[:filename]))
    if File.exists?(file_name)
      render :file => file_name and return
    else
      render :status => 404 and return
    end
  end
end