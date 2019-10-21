# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @stranger_danger = users(:two)
    [@user, @stranger_danger].each do |u|
      u.update!(password: 'foobar', password_confirmation: 'foobar')
    end
    @user_changes_boilerplate = {
      name: 'User McUserton',
      email: 'new_user@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
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
      post(users_path, params: { user: @user_changes_boilerplate })
    end
    newest_user = User.order(created_at: :asc).last
    assert_redirected_to user_url(newest_user)
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit when user is logged in' do
    log_in_as(@user)
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should redirect edit when user is not logged in' do
    get edit_user_url(@user)
    assert_redirected_to login_path
  end

  test 'should redirect edit when user is logged in as someone else' do
    log_in_as(@stranger_danger)
    assert currently_logged_in?
    get edit_user_url(@user)
    assert_redirected_to root_path
  end

  test 'should update user when user is logged in' do
    log_in_as(@user)
    patch(user_url(@user), params: { user: @user_changes_boilerplate })
    assert_redirected_to user_url(@user)
  end

  test 'should redirect update when user is not logged in' do
    patch(user_url(@user), params: { user: @user_changes_boilerplate })
    assert_redirected_to login_path
  end

  test 'should redirect update when user is logged in as someone else' do
    log_in_as(@stranger_danger)
    assert currently_logged_in?
    patch(user_url(@user), params: { user: @user_changes_boilerplate })
    assert_redirected_to root_path
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
