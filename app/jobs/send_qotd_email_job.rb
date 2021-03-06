# frozen_string_literal: true

class SendQotdEmailJob < ApplicationJob
  queue_as :default

  def perform
    # w/o 'order', uses uuid; w/ 'find_by', appears to order by created_at?
    quote =
      Quote
      .includes(:author)
      .where(times_sent: 0)
      .order('RANDOM()')
      .first

    # TODO: send 'hey, increment times_sent' mail to Admin
    return unless quote.present?

    User.where(receive_qotd: true).find_each do |user|
      UserMailer.quote_of_the_day(user, quote).deliver_now
    end

    quote.update_columns(
      times_sent: (quote.times_sent += 1),
      most_recently_sent_at: Date.today
    )
  end
end
