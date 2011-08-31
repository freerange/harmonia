require "tomafro/deploy"

server "gofreerange.com", :app

set :application, "harmonia"
set :repository,  "git@github.com:freerange/harmonia.git"

set :whenever_command, "bundle exec whenever"
set(:whenever_identifier)   { application }
set(:whenever_update_flags) { "--update-crontab #{whenever_identifier} -s password=#{password}" }
set(:whenever_clear_flags)  { "--clear-crontab #{whenever_identifier}" }

before "deploy:update_code", "whenever:clear_crontab"
after "deploy:update_code", "whenever:update_crontab"
after "deploy:rollback", "whenever:update_crontab"

namespace :whenever do
  desc "Update application's crontab entries using Whenever"
  task :update_crontab, :roles => :app do
    run "cd #{deploy_to} && #{whenever_command} #{whenever_update_flags}"
  end

  desc "Clear application's crontab entries using Whenever"
  task :clear_crontab, :roles => :app do
    run "cd #{deploy_to} && #{whenever_command} #{whenever_clear_flags}"
  end
end