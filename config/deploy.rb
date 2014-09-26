require "bundler/capistrano"
require "rvm/capistrano"

set :application, "107.170.34.103"
set :repository,  "git@github.com:gil27/gil.gomes.com.br.git"
set :scm, :git

role :web, "107.170.34.103"
role :app, "107.170.34.103"
role :db,  "107.170.34.103", :primary => true

set :deploy_to, "/home/gil/gilgomes.com.br"
set :user, "gil"
set :use_sudo, false
set :keep_releases, 5

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && touch tmp/restart.txt"
  end
  
  task :jekyll, :roles => :app do
    run "cd #{release_path}; bundle exec jekyll build"
    run "cp #{deploy_to}/shared/_config.yml #{release_path}/"
  end

  task :bundleinstall, :roles => :app do
    run "cd #{release_path}; bundle exec bundle install"
  end

  task :rvmrc, :roles => :app do
    run "rm -f #{release_path}/.rvmrc"
  end
end

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

set :rvm_type, :user
set :rvm_ruby_string, 'ruby-2.1.3'

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

after :deploy, 'deploy:jekyll'
after 'deploy:update_code', 'deploy:bundleinstall', "deploy:restart"