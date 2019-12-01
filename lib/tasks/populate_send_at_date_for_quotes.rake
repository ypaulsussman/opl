# frozen_string_literal: true

desc 'I add a send-at date to any quote without one'
task populate_send_at_date_for_quotes: :environment do
  base_date = Quote.order(:next_send_at).pluck(:next_send_at).first
  base_date = Date.tomorrow if base_date.nil?

  # No implicit_order_column on Quote model, so sorting by pk (here, a uuid)
  # works ~as well as explicitly randomizing before -- but doesn't trip the
  # internal ordering that .find_each forces (and needs in order to iterate.)

  Quote.where(next_send_at: nil).find_each.with_index do |quote, index|
    quote.update_column(:next_send_at, base_date + index)
  end
end
