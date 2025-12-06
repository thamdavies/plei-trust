# frozen_string_literal: true

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { 1 }
max_threads_count = ENV.fetch("RAILS_MAX_THREADS", 2)
threads min_threads_count, max_threads_count

# Redirect STDOUT and STDERR to files specified. The 3rd parameter
# ("append") specifies whether the output is appended, the default is "false".
stdout_redirect "log/puma.stdout.log", "log/puma.stderr.log", true

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
# worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
# port ENV.fetch("PORT", 3000)
socket_path = ENV.fetch("SOCKET_PATH", "/home/deploy/dnm/shared/tmp/sockets/puma.sock")
bind "unix://#{socket_path}"

# Specifies the `environment` that Puma will run in.
#
environment "production"

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE", "tmp/pids/server.pid")

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
preload_app!

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart
