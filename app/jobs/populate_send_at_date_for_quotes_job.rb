# frozen_string_literal: true

class PopulateSendAtDateForQuotesJob < ApplicationJob
  queue_as :default

  def perform(backlog_threshhold)
    return if Quote.where(next_send_at: nil, times_sent: 0).size < backlog_threshhold

    # If no quotes have send-at dates, start with tomorrow; otherwise start with
    # the day after (the furthest future date on which an email will send)
    base_date =
      Quote
      .where.not(next_send_at: nil)
      .order(:next_send_at)
      .pluck(:next_send_at)
      .last

    if base_date.nil?
      base_date = Date.tomorrow
    else
      base_date += 1.day
    end

    # No implicit_order_column on Quote model, so sorting by pk (here, a uuid)
    # works ~as well as explicitly randomizing before -- but doesn't trip the
    # internal ordering that find_each forces (and needs in order to iterate.)
    Quote.where(next_send_at: nil, times_sent: 0).find_each.with_index do |quote, index|
      quote.update_column(:next_send_at, base_date + index)
    end
  end
end
