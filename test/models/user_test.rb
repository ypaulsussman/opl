# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @user.password = 'foobar'
    @user.password_confirmation = 'foobar'
  end

  test 'validates name presence' do
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'validates name length' do
    @user.name = 'a' * 256
    assert_not @user.valid?
  end

  test 'validates email presence' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'validates email length' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'validates email format' do
    valid_addresses =
      %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'rejects invalid email formats' do
    invalid_addresses =
      %w[user@example,com user_at_foo.org user.name@example.
         foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'validates email uniqueness' do
    duplicate_user = @user.dup
    duplicate_user.email.upcase!
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'saves email as lower-case' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    @user.email = mixed_case_email
    @user.password = 'foobar'
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'enforces password presence' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'ensures password minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'returns false for user with nil digest' do
    assert_not @user.authenticated?(:remember_me, '')
  end
end
