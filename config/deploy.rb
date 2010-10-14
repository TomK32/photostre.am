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

namespace :bundle do
  task :install do
    run "bundle install"
  end
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
    run "god -c #{release_path}/config/config.god"
  end
  desc "screenshots"
  task :screenshots, :roles => [:web] do
    top.upload(File.expand_path('../../public/screenshots', __FILE__),
        "#{shared_path}/public/", :via => :scp, :recursive => true, :mode => '0755')
  end
  desc "link shared files"
  task :link_shared_files, :roles => [:app] do
    run "ln -nsf #{shared_path}/cached-copy/vendor/cache #{release_path}/vendor/cache"
    %w(
      config/database.mongo.yml
      config/flickr.yml
      public/screenshots
      log
    ).each do |f|
      run "ln -nsf #{shared_path}/#{f} #{release_path}/#{f}"
    end
  end
end