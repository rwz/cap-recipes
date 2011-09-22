require File.expand_path(File.dirname(__FILE__) + '/../utilities')

Capistrano::Configuration.instance(true).load do
  set :delayed_job_role, :app

  namespace :delayed_job do
    desc "Start delayed_job process"
    task :start, :roles => delayed_job_role do
      utilities.with_role(delayed_job_role) do
        try_sudo "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job start"
      end
    end

    desc "Stop delayed_job process"
    task :stop, :roles => delayed_job_role do
      utilities.with_role(delayed_job_role) do
                try_sudo "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job stop"
      end
    end

    desc "Restart delayed_job process"
    task :restart, :roles => delayed_job_role do
      utilities.with_role(delayed_job_role) do
        try_sudo "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job restart"
      end
    end
  end
end
