# config valid only for current version of Capistrano
lock '3.4.0'

role :app, %w{capistrano}
role :web, %w{capistrano}
role :db, %w{capistrano} # .ssh/config に capistrano の設定を書いておく

set :application, 'hotdog'
set :repo_url, 'git@github.com:hystking/hotdog' # .ssh/config に github.com の設定を書いておく

ask :branch, 'master'

set :rbenv_ruby, "2.2.3" 

# symbolic link
set :linked_dirs, %w{tmp/pids tmp/cache tmp/sockets vendor/bundle}

namespace :deploy do
  desc "Run rake db:seed"
  task :db_seed do
    on roles(:db) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end
  
  desc "Run rake db:create"
  task :db_create do
    on roles(:db) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end

  before :migrate, :db_create
  after :migrate, :db_seed
end
