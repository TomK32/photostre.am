set :application, "photostre.am"
set :repository,  "git@github.com:TomK32/das-photowall.git"

set :scm, :git
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"

role :web, "ananasblau.com"
role :app, "ananasblau.com"
role :db,  "ananasblau.com", :primary => true

after "deploy:update_code", "deploy:link_shared_files"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "link shared files"
  task :link_shared_files, :roles => [:app] do
    %w(
      config/database.yml
      config/flickr.yml
      themes/websites
    ).each do |f|
      run "ln -nsf #{shared_path}/#{f} #{release_path}/#{f}"
    end
  end
end