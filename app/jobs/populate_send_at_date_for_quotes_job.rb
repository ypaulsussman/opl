# frozen_string_literal: true

# This job (and the identically-named rake task) was created before
# the `Quote#add_next_send_at` callback; that method supercedes this file.

# (I wanted the original ~1k quotes sent to me randomly, rather than in the sequence
# they appear in the .csv; this job accomplishes that, but I doubt its value to other users.)

# If you, too, want your quotes mailed out in an effectively-random sequence, comment out
# `before_create :add_next_send_at` in `quote.rb` before running the initial `rake db:seed`,
# then run `$ rake populate_send_at_date_for_quotes` immediately after.

class PopulateSendAtDateForQuotesJob < ApplicationJob
  queue_as :default

  def perform
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
end
