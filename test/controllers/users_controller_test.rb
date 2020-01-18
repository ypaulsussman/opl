# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    add_users
    @user_changes_boilerplate = {
      name: 'User McUserton',
      email: 'new_user@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  test 'should get index, if admin' do
    @user_uno.update_attribute(:admin, true)
    @user_uno.reload
    log_in_as(@user_uno)
    get users_url
    assert_response :success
  end

  test 'should reject user-index, if non-admin' do
    log_in_as(@user_uno)
    get users_url
    assert_redirected_to root_path
  end

  test 'should destroy user, if admin' do
    @user_uno.update_attribute(:admin, true)
    @user_uno.reload
    log_in_as(@user_uno)
    assert_difference('User.count', -1) do
      delete user_url(@user_dos)
    end
    assert_redirected_to users_url
  end

  test 'should reject user-destroy, if non-admin' do
    log_in_as(@user_uno)
    assert_no_difference('Author.count') { delete user_url(@user_dos) }
    assert_redirected_to root_path
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should redirect new when signup is turned off' do
    Rails.configuration.allow_signups = false
    get signup_path
    assert_redirected_to root_path
    Rails.configuration.allow_signups = true
  end

  test 'should create user' do
    assert_difference('User.count', 1) do
      post(users_path, params: { user: @user_changes_boilerplate })
    end
    assert_redirected_to root_path
  end

  test 'should redirect create-user when signup is turned off' do
    Rails.configuration.allow_signups = false
    assert_no_difference('User.count') do
      post(users_path, params: { user: @user_changes_boilerplate })
    end
    assert_redirected_to root_path
    Rails.configuration.allow_signups = true
  end

  test 'should get edit when user is logged in' do
    log_in_as(@user_uno)
    get edit_user_url(@user_uno)
    assert_response :success
  end

  test 'should redirect edit when user is not logged in' do
    get edit_user_url(@user_uno)
    assert_redirected_to login_path
  end

  test 'should redirect edit when user is logged in as someone else' do
    log_in_as(@user_dos)
    assert currently_logged_in?
    get edit_user_url(@user_uno)
    assert_redirected_to root_path
  end

  test 'should update user when user is logged in' do
    log_in_as(@user_uno)
    patch(user_url(@user_uno), params: { user: @user_changes_boilerplate })
    assert_response :success
    assert_equal @user_uno.reload.name, 'User McUserton'
  end

  test 'should redirect update when user is not logged in' do
    patch(user_url(@user_uno), params: { user: @user_changes_boilerplate })
    assert_redirected_to login_path
  end

  test 'should redirect update when user is logged in as someone else' do
    log_in_as(@user_dos)
    assert currently_logged_in?
    patch(user_url(@user_uno), params: { user: @user_changes_boilerplate })
    assert_redirected_to root_path
  end

  test 'should reject changes to admin attribute' do
    log_in_as(@user_uno)
    assert_not @user_uno.admin?
    patch(user_url(@user_uno), params: { user: @user_changes_boilerplate.merge!(admin: true) })
    assert_not @user_uno.reload.admin?
  end
end
