set :application, "photostre.am"
set :repository,  "git@github.com:TomK32/das-photowall.git"

set :scm, :git
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"

role :web, "photostre.am"
role :app, "photostre.am"
role :db,  "photostre.am", :primary => true

after "deploy:update_code", "deploy:link_shared_files"
after "deploy:update_code", "bundle:pack"

namespace :bundle do
  desc "pack"
  task :pack do
    run "cd #{release_path}; bundle install; bundle pack"
  end
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  desc "link shared files"
  task :link_shared_files, :roles => [:app] do
    %w(
      config/database.mongo.yml
      config/flickr.yml
      public/themes
      log
    ).each do |f|
      run "ln -nsf #{shared_path}/#{f} #{release_path}/#{f}"
    end
  end
end