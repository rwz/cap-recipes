require File.expand_path(File.dirname(__FILE__) + '/../utilities')

Capistrano::Configuration.instance(true).load do
  set :delayed_script_path, "#{current_path}/script/delayed_job"
  set :delayed_job_role, :app

  namespace :delayed_job do
    desc "Start delayed_job process"
    task :start, :roles => delayed_job_role do
      utilities.with_role(delayed_job_role) do
        try_sudo "RAILS_ENV=#{rails_env} ruby #{delayed_script_path} start"
      end
    end

    desc "Stop delayed_job process"
    task :stop, :roles => delayed_job_role do
      utilities.with_role(delayed_job_role) do
        try_sudo "RAILS_ENV=#{rails_env} ruby #{delayed_script_path} stop"
      end
    end

    desc "Restart delayed_job process"
    task :restart, :roles => delayed_job_role do
      utilities.with_role(delayed_job_role) do
        delayed_job.stop
        sleep(4)
        try_sudo "killall -s TERM delayed_job; true"
        delayed_job.start
      end
    end
  end
end
