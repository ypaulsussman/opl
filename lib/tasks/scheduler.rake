# frozen_string_literal: true

desc 'This task is called by the Heroku scheduler add-on'
task send_qotd_email: :environment do
  SendQotdEmailJob.perform_later
end
