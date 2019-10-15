# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test 'validates name' do
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'validates email' do
    @user.email = ' '
    assert_not @user.valid?
  end
end
