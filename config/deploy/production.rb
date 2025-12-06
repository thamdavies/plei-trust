# frozen_string_literal: true

set :rails_env, "production"
set :bundle_flags, "--no-deployment"
set :deploy_to, "/home/ubuntu/dnm"

set :application, "dnm_production"

# Web deploy
server "103.200.23.127", roles: [ :web, :db, :app ], ssh_options: fetch(:ssh_options)

# Bot deploy
server "103.200.23.127", roles: [ :bot ], ssh_options: fetch(:ssh_options)

# Default value for :linked_files is []
append :linked_files, "config/credentials/production.key"
