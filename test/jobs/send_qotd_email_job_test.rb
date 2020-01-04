# frozen_string_literal: true

require 'test_helper'

class SendQotdEmailJobTest < ActiveJob::TestCase
  setup do
    @our_qotd = quotes(:one)

    @subbed_user = users(:one)
    @subbed_user.update_attribute(:receive_qotd, true)

    @unsubbed_user = users(:two)
  end

  test 'does nothing if no quote is available for today' do
    assert_no_difference('ActionMailer::Base.deliveries.count') do
      @our_qotd.update!(next_send_at: Date.tomorrow)
      SendQotdEmailJob.perform_now
    end
  end

  test "sends today's quote solely to subscribed users" do
    assert_difference('ActionMailer::Base.deliveries.count', 1) do
      @our_qotd.update!(next_send_at: Date.today)
      SendQotdEmailJob.perform_now
    end

    mail = ActionMailer::Base.deliveries.first
    assert_equal @subbed_user.email, mail.to.first
    assert_match @our_qotd.passage, mail.body.encoded
  end
end
