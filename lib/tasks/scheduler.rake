# frozen_string_literal: true

desc 'This task is called by the Heroku scheduler add-on'
task send_qotd_email: :environment do
  quote = Quote.includes(:author).find_by(next_send_at: Date.today)

  User.where(receive_qotd: true).find_each do |user|
    UserMailer.quote_of_the_day(user, quote).deliver_now
  end

  quote.update_columns(
    most_recently_sent_at: quote.next_send_at,
    next_send_at: nil
  )
end
