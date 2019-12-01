# frozen_string_literal: true

desc 'This task is called by the Heroku scheduler add-on'
task send_qotd_email: :environment do
  quote = Quote.includes(:author).find_by(next_send_at: Date.today)
  puts "today we've got #{quote.passage} by #{quote.author.name}"

  puts 'Sending qotd email to opt-in users...'
  User.where(receive_qotd: true).find_each do |user|
    UserMailer.quote_of_the_day(user, quote).deliver_now
  end
  puts '...and done!'
end
