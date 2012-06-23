default_run_options[:pty] = true
set :application, "toerdepoele"
set :user, "tdp"
set :password, "tdp2012"
set :db_name, "tdp"
set :domain, "www.toerdepoele.nl"
set :host, "vps.mvlweb.nl"
set :deploy_to, "/home/#{user}/app"

set :repository,  "git@github.com:mvlwn/TDF.git"

set :scm, :git
set :scm_passphrase, password
#set :git_enable_submodules, 1
set :use_sudo, false

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, host
role :web, host
role :db,  host, :primary => true

require 'erb'

before "deploy:setup", :db
after "deploy:update_code", "db:symlink"
after "deploy:update_code", "hosting:restart"

namespace :hosting do
  task :restart, :roles => :app do
    run "touch #{release_path}/tmp/restart.txt"
  end

  task :setup_log do
    run "mkdir #{shared_path}/log"
  end

  task :setup_tmp do
    run "mkdir #{shared_path}/tmp"
  end

  task :tail, :roles => :app do
    run "tail -f #{release_path}/log/production.log"
  end
end

namespace :db do
  desc "Create database yaml in shared path"
  task :default do
    db_config = ERB.new <<-EOF
    base: &base
      adapter: mysql
      socket: /tmp/mysql.sock
      username: #{db_name}
      password: #{password}

    development:
      database: #{db_name}
      <<: *base

    test:
      database:
      <<: *base

    production:
      database: #{db_name}
      <<: *base
    EOF

    run "mkdir -p #{shared_path}/config"
    put db_config.result, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end
