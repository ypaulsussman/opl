# frozen_string_literal: true

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'account_activation' do
    user = users(:one)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal 'OPL Up, Friend!', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['noreply@example.com'], mail.from
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  test 'password_reset' do
    user = users(:one)
    user.password_reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal 'Password reset', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['noreply@example.com'], mail.from
    assert_match user.password_reset_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  test 'quote_of_the_day' do
    user = users(:one)
    mail = UserMailer.quote_of_the_day(user)
    day_of_week = Time.new.strftime('%A')
    assert_equal "OPLquote for #{Date.today.to_formatted_s(:long_ordinal)}", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['noreply@example.com'], mail.from
    assert_match "What up it's #{day_of_week}!!", mail.body.encoded
  end
end
