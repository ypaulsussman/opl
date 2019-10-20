# frozen_string_literal: true

require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:one)
  end

  test 'current_user returns correct (remembered) user even in absence of session' do
    remember(@user)
    assert_equal @user, current_user
    assert currently_logged_in?
  end

  test 'current_user returns nil if session is nil AND remember_me_digest is incorrect' do
    remember(@user)
    @user.update_attribute(:remember_me_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
