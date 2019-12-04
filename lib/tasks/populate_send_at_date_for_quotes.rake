# frozen_string_literal: true

desc 'I add a send-at date to any quote without one'
task populate_send_at_date_for_quotes: :environment do
  # If no quotes have send-at dates, start with tomorrow; otherwise
  # start with (the day after the furthest future date)

  @base_date = Quote.order(:next_send_at).pluck(:next_send_at).first
  if @base_date.nil?
    @base_date = Date.tomorrow
  else
    @base_date + 1.day
  end

  # Get an ascending array of every individual number of (times quotes have been sent);
  # bucket quotes by their number-of-times-already-sent,
  # then add a `next_send_at` date to any quote missing one in the 'bucket'
  Quote.order(:times_sent).distinct(:times_sent).pluck(:times_sent).each do |i|
    quotes_needing_send_at_dates = Quote.where(next_send_at: nil, times_sent: i)

    # No implicit_order_column on Quote model, so sorting by pk (here, a uuid)
    # works ~as well as explicitly randomizing prior -- but doesn't trip the
    # internal ordering that find_each forces (and needs in order to iterate.)
    quotes_needing_send_at_dates.find_each.with_index do |quote, index|
      quote.update_column(:next_send_at, @base_date + index)
      # ensure the next bucket of quotes begins where the previous one ended
      @base_date += (index + 1.day) if quotes_needing_send_at_dates.size == (index + 1)
    end
  end
end
