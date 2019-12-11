# frozen_string_literal: true

require 'test_helper'

class PopulateSendAtDateForQuotesJobTest < ActiveJob::TestCase
  self.use_transactional_tests = true

  setup do
    @quote_uno = quotes(:one)
    @quote_dos = quotes(:two)
    @author = authors(:one)
  end

  test 'does nothing if new quotes are fewer than bucket size' do
    @new_quote = Quote.create!(passage: 'foo', author: @author)
    assert_nil @new_quote.next_send_at
    PopulateSendAtDateForQuotesJob.perform_now(2)
    assert_nil @new_quote.next_send_at
  end

  test 'adds tomorrow as send-at date when no other quotes are present' do
    Quote.destroy_all
    @new_quote = Quote.create!(passage: 'foo', author: @author)
    assert_nil @new_quote.next_send_at
    PopulateSendAtDateForQuotesJob.perform_now(1)
    assert_equal Time.zone.tomorrow.midnight, @new_quote.reload.next_send_at
  end

  test 'adds closest empty send-at date when other quotes are present' do
    @quote_uno.update!(next_send_at: Date.tomorrow)
    @quote_dos.update!(next_send_at: Date.tomorrow + 1.day)
    @new_quote = Quote.create!(passage: 'foo', author: @author)

    assert_nil @new_quote.next_send_at
    PopulateSendAtDateForQuotesJob.perform_now(1)
    assert_equal (Time.zone.tomorrow + 2.days).midnight, @new_quote.reload.next_send_at
  end
end
