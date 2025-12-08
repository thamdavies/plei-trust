# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :repo_url, "git@github.com:thamdavies/plei-trust.git"

# Default branch is :main
# ask :branch, %x(git rev-parse --abbrev-ref HEAD).chomp
set :branch, "main"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for linked_dirs is []
append :linked_files, ".env"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads", "storage"

# Default value for default_env is {}
set :default_env, { path: "/home/ubuntu/.nvm/versions/node/v24.4.1/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 3
set :keep_releases, 3

# Uncomment the following to require manually verifying the host key before first deploy.
set :ssh_options, verify_host_key: :secure

# Global options
# --------------
set :ssh_options, {
  keys: [ "~/.ssh/myvps" ],
  user: "ubuntu",
  forward_agent: false,
  auth_methods: [ "publickey" ]
}

# Puma configuration
set :puma_use_login_shell, true
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_service_unit_type, :notify  # Uses sd_notify gem

# Whenever configuration
set :whenever_identifier, -> { "dnm" }
set :assets_roles, [ :web, :app ]
set :whenever_roles, [ :bot ]
