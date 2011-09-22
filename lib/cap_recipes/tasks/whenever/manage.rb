Capistrano::Configuration.instance(true).load do
  namespace :whenever do
    desc "Update the crontab file"
    task :update_crontab, :roles => :db do
      run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec whenever --update-crontab #{application}_#{rails_env}"
    end
  end
end