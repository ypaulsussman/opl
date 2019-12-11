# frozen_string_literal: true

desc 'I add a send-at date to any as-yet-never-sent quote'
task populate_send_at_date_for_quotes: :environment do
  PopulateSendAtDateForQuotesJob.perform_later
end
