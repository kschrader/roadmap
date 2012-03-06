#
# Flipstone deployment recipes
#
require "flipstone-deployment/capistrano/rails"

#
# Application environment defaults
# These should be set by the (environment) task, run first
#
# set :rails_env, 'development'
set :instance, "localhost"
set :branch, "master"
set :deployment_safeword, "roadtonowhere"
set :rvm_ruby_string, '1.9.2'
set :appserver_name, :zbatery
#
# environment settings (by task)
#
desc "Runs any following tasks to production environment"
task :production do
  set :rails_env, "production"
  set :instance, "roadmap.flipstone.com"
  set_env
end

desc "Sets Capistrano environment variables after environment task runs"
task :set_env do
  role :web,      "#{instance}"
  role :app,      "#{instance}"
  role :db,       "#{instance}", :primary => true

  set :application, "roadmap"
  set :deploy_to, "/srv/#{application}-#{rails_env}"
  set :scm, "git"
  set :local_scm_command, "git"
  set :scm_passphrase, ""
  set :deploy_via, :remote_cache
  set :repository, "git://github.com/14to9/#{application}.git"
  set :use_sudo, false
  set :user, "ubuntu"

  ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/fs-remote.pem"]
  ssh_options[:paranoid] = false
  ssh_options[:user] = "ubuntu"

  default_run_options[:pty] = true

  set :zbatery, {
    port: 10009,
    worker_processes: 2,
    worker_timeout: 15, #in seconds
    worker_connections: 100
  }

  set :nginx_cfg, {
    port: 80
  }
end
