# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count', 1) do
      post(
        users_path,
        params: {
          user: {
            name: 'User McUserton',
            email: 'new_user@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      )
    end
    newest_user = User.order(created_at: :asc).last
    assert_redirected_to user_url(newest_user)
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    patch(
      user_url(@user), 
      params: {
        user: {
          name: 'Who Dis',
          email: 'new_email@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    )
    assert_redirected_to user_url(@user)
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
