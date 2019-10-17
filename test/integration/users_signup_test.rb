# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post(
        users_path,
        params: {
          user: {
            name: '',
            email: 'user@invalid',
            password: 'foo', password_confirmation: 'bar'
          }
        }
      )
    end
    assert_template 'users/new'
    assert_select '.field_with_errors', 8
    assert_select '#error_explanation > h2', text: '4 errors prohibited this user from being saved:'
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post(
        users_path,
        params: {
          user: {
            name: 'Example User',
            email: 'user@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      )
      follow_redirect!
      assert_template 'users/show'
      assert_select '#notice', 'User was successfully created.'
    end
  end
end
