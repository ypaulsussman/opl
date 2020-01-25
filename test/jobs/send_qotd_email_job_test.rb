# frozen_string_literal: true

require 'test_helper'

class SendQotdEmailJobTest < ActiveJob::TestCase
  setup do
    Quote.all.each { |q| q.update!(times_sent: 1) }

    @subbed_user = users(:one)
    @subbed_user.update_attribute(:receive_qotd, true)

    @unsubbed_user = users(:two)
  end

  test 'does nothing if no quote is available for today' do
    assert_no_difference('ActionMailer::Base.deliveries.count') do
      SendQotdEmailJob.perform_now
    end
  end

  test "sends today's quote solely to subscribed users" do
    @our_qotd = Quote.first
    @our_qotd.update_attribute(:times_sent, 0)

    assert_difference('ActionMailer::Base.deliveries.count', 1) do
      SendQotdEmailJob.perform_now
    end

    mail = ActionMailer::Base.deliveries.first
    assert_equal @subbed_user.email, mail.to.first
    assert_match @our_qotd.passage, mail.body.encoded
  end
end
