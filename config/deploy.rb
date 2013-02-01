$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, 'ruby-1.9.3-head@rails32'
set :rvm_type, :user
set :rvm_bin_path, "$HOME/bin"

# Server
set :application, "rails-forum.cz"
set :deploy_to, "/var/www/papricek/#{application}"
set :user, "papricek"
set :use_sudo, false
set :domain, "zviratko.inted.cz"
server domain, :app, :web
role :db, domain, :primary => true


# scm settings
set :repository, "git://github.com/papricek/rails-forum.git"
set :scm, "git"
set :scm_verbose, true
set :branch, "master"
set :keep_releases, 10
#set :deploy_via, :remote_cache

# Tasks
after :deploy do
  deploy.bundle_install
  site.create_symlinks
  site.precompile_assets
  passenger.restart
  deploy.cleanup
  deploy.migrate
end

namespace :deploy do
  desc "Override to do nothing when restarting"
  task :restart do
    # do nothing since we're using passengers restart mechanism
  end

  desc "run 'bundle install' to install Bundler's packaged gems for the current deploy"
  task :bundle_install, :roles => :app do
    run "cd #{release_path} && bundle install --without test"
  end

end

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end


namespace :site do
  desc "Create or update symlinks "
  task :create_symlinks do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/db/production.sqlite3 #{release_path}/db/production.sqlite3"
  end

  desc "Precompile assets"
  task :precompile_assets do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end

end