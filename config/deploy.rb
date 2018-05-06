# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "reflections"
set :repo_url, "https://github.com/ildarsafin/myreflections"

set :deploy_to, "/home/deploy/reflections"

set :linked_files, %w(config/database.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system)

set :keep_releases, 3

require "bundler/capistrano"
require "rbenv/capistrano"
before "deploy:assets:precompile", "bundle:install"

namespace :deploy do
  before :updated, :copy_database_config do
    on roles(:all) do
      within release_path do
        execute :cp, "#{release_path}/config/database.yml.example #{shared_path}/config/database.yml"
        # execute :rake, "db:create RAILS_ENV=#{fetch(:stage)}"
        execute :rake, "db:migrate RAILS_ENV=#{fetch(:stage)}"
      end
    end
  end

  before :published, :set_db_seed do
    on roles(:all), in: :sequence do
      within release_path do
        execute :rake, "db:seed RAILS_ENV=#{fetch(:stage)}"
      end
    end
  end

  after :published, :restart do
    on roles(:all), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end
end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
