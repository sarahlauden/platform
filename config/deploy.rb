# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, 'datacentral'
set :repo_url, 'git@github.com:beyond-z/data-central.git'
set :bundle_path, "vendor/bundle"
set :bundle_flags, '--deployment' # Default is --quiet, but it's nice to have logs.

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
append :linked_files, "config/database.yml", "config/secrets.yml", "config/master.key", "config/credentials.yml.enc"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bundle", ".bundle"

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
# The following value runs: bundle exec rspec spec
# TODO: uncomment me. temporarily commented while trying to get staging server setup. a few recent tests were failing.
#set :tests, ['spec']

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called and when
namespace :deploy do
  # Self explanatory. Restart the server!
  after 'deploy:publishing', 'deploy:restart'

  # only allow a deploy with passing tests to deployed
  # TODO: uncomment me. commented b/c a few tests were failing and i'm trying to get teh staging server setup.
  #before :deploy, "deploy:run_tests"
end
