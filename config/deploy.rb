# config valid only for current version of Capistrano
lock '3.8.1'

set :application, 'cuxibamba-post-scheduler'
set :repo_url, 'git@github.com:macool/cuxibamba-post-scheduler.git'

# Default branch is :master
set :branch, ENV['BRANCH'] || 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/wuxi/cuxibamba-post-scheduler"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

append :linked_files, '.env'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

set :passenger_restart_with_touch, true

set :default_env, {
  'RAILS_ENV' => fetch(:stage)
}

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:db) do
      within release_path do
        execute :rake, 'db:mongoid:create_indexes'
      end
    end
  end
end
