Capistrano::Configuration.instance(true).load do
  namespace :rails do
    # ===============================================================
    # UTILITY TASKS
    # ===============================================================
    desc "Symlinks the shared/config/database yaml to release/config/"
    task :symlink_db_config, :roles => :app do
      puts "Copying database configuration to release path"
      try_sudo "rm #{release_path}/config/database.yml -f"
      try_sudo "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end

    desc "Repair permissions to allow user to perform all actions"
    task :repair_permissions, :roles => :app do
      puts "Applying correct permissions to allow for proper command execution"
      try_sudo "chmod -R 744 #{current_path}/log #{current_path}/tmp"
      try_sudo "chown -R #{user}:#{user} #{current_path}"
      try_sudo "chown -R #{user}:#{user} #{current_path}/tmp"
    end

    desc "Displays the production log from the server locally"
    task :tail, :roles => :app do
      stream "tail -f #{shared_path}/log/production.log"
    end

    desc "Pings localhost to startup server"
    task :ping, :roles => :app do
      puts "Pinging the web server to start it"
      run "wget -O /dev/null #{fetch(:local_ping_path, 'http://localhost')} 2>/dev/null"
    end
    
    # ===============================================================
    # MAINTENANCE TASKS
    # ===============================================================
    namespace :sweep do
      desc "Clear file-based fragment and action caching"
      task :log, :roles => :app  do
        puts "Sweeping all the log files"
        try_sudo "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake log:clear"
      end

      desc "Clear file-based fragment and action caching"
      task :cache, :roles => :app do
        puts "Sweeping the fragment and action cache stores"
        try_sudo "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake tmp:cache:clear"
      end
    end
  end
end