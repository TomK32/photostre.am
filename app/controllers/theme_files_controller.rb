class ThemeFilesController < ApplicationController
  def show
    render :file => File.join(current_theme_path, 'public', params[:file_type], File.join(params[:filename]))
  end
end