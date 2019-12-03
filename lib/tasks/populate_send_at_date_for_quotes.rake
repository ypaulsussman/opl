# frozen_string_literal: true

desc 'I add a send-at date to any quote without one'
task populate_send_at_date_for_quotes: :environment do
  # If no quotes have send-at dates, start with tomorrow; otherwise
  # start with (the day after the furthest future date)

  base_date = Quote.order(:next_send_at).pluck(:next_send_at).first
  if base_date.nil?
    base_date = Date.tomorrow
  else
    base_date + 1.day
  end

  # No implicit_order_column on Quote model, so sorting by pk (here, a uuid)
  # works ~as well as explicitly randomizing before -- but doesn't trip the
  # internal ordering that find_each forces (and needs in order to iterate.)

  Quote.where(next_send_at: nil).find_each.with_index do |quote, index|
    quote.update_column(:next_send_at, base_date + index)
  end
end
