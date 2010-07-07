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
  task :pack, :roles => [:app] do
    run "cd #{release_path}; bundle install; bundle pack"
  end
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  desc "screenshots"
  task :screenshots, :roles => [:web] do
    top.upload(File.expand_path('../../public/screenshots', __FILE__),
        "#{shared_path}/public/", :via => :scp, :recursive => true, :mode => '0755')
  end
  desc "link shared files"
  task :link_shared_files, :roles => [:app] do
    %w(
      config/database.mongo.yml
      config/flickr.yml
      public/screenshots
      log
    ).each do |f|
      run "ln -nsf #{shared_path}/#{f} #{release_path}/#{f}"
      run "cd #{release_path}; /etc/init.d/photostream-worker restart"
    end
  end
end