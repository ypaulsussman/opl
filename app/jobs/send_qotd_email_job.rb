# frozen_string_literal: true

class SendQotdEmailJob < ApplicationJob
  queue_as :default

  def perform
    quote = Quote.includes(:author).find_by(next_send_at: Date.today)

    return unless quote.present?

    User.where(receive_qotd: true).find_each do |user|
      UserMailer.quote_of_the_day(user, quote).deliver_now
    end

    quote.update_columns(
      most_recently_sent_at: quote.next_send_at,
      next_send_at: nil
    )
  end
end