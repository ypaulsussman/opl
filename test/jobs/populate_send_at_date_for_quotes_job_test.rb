# frozen_string_literal: true

require 'test_helper'

class PopulateSendAtDateForQuotesJobTest < ActiveJob::TestCase
  # setup do
  #   @author = authors(:one)
  #   @quote = Quote.create!(passage: 'foo', author: @author)
  # end

  # test 'on quote creation, adds tomorrow as send-at date when no other quotes are present' do
  #   assert_nil @quote.next_send_at
  #   PopulateSendAtDateForQuotesJob.perform_now
  #   assert_equal @quote.next_send_at, Date.tomorrow
  # end

  # test 'on quote creation, adds closest empty send-at date when other quotes are present' do
  #   Quote.create!(passage: 'foo', author: @author, next_send_at: Date.tomorrow)
  #   @new_quote = Quote.create!(passage: 'bar', author: @author)
  #   assert_equal @new_quote.next_send_at, (Date.tomorrow + 1.day)
  # end
end
