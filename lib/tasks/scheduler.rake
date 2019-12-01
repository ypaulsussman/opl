# frozen_string_literal: true

desc 'This task is called by the Heroku scheduler add-on'
task send_qotd_email: :environment do
  puts 'Sending qotd email to opt-in users...'
  # TODO: remove below when testing complete
  puts "btw, #{User.where(receive_qotd: true).pluck(:email)} will get mail, I think"
  User.where(receive_qotd: true).find_each do |user|
    UserMailer.quote_of_the_day(user).deliver_now
  end
  puts '...and done!'
end
