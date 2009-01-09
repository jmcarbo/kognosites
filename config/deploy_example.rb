#############################################################
#	Application
#############################################################

set :application, "kognosites"
set :deploy_to, "/webapps/kognosites"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm_verbose, true
set :rails_env, "production" 

#############################################################
#	Servers
#############################################################

set :user, "deploy"
set :domain, "your_server"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :branch, "master"
set :scm_user, 'git'
set :repository, "git://github.com/jmcarbo/kognosites.git"
set :deploy_via, :remote_cache

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Create the database yaml file"
  task :after_update_code do
    db_config = <<-EOF
    development:    
      adapter: mysql
      encoding: utf8
      username: root
      password: 
      database: kognosites_production
      host: localhost
    production:    
      adapter: mysql
      encoding: utf8
      username: root
      password: 
      database: kognosites_production
      host: localhost
    EOF
    
    put db_config, "#{release_path}/config/database.yml"
    
    #########################################################
    # Uncomment the following to symlink an uploads directory.
    # Just change the paths to whatever you need.
    #########################################################
    
    # desc "Symlink the upload directories"
    task :before_symlink do
       run "mkdir -p #{shared_path}/files"
       run "ln -s #{shared_path}/files #{release_path}/files"
       run "ln -s #{shared_path}/files #{release_path}/public/files"
    end
  
  end
    
  desc "Create mysql database"
  task :create_database do
      run "mysqladmin create kognosites_production"
  end
  
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
end