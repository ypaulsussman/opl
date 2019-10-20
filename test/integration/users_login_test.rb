# frozen_string_literal: true

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user.update!(password: 'foobar', password_confirmation: 'foobar')
  end

  test 'invalid login information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }
    assert_not currently_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'valid login information' do
    get login_path
    assert_template 'sessions/new'
    post(
      login_path,
      params: {
        session: {
          email: @user.email,
          password: @user.password
        }
      }
    )
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    delete logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'quotes/index'
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'login with remembering' do
    log_in_as(@user)
    assert_equal @user.id, assigns(:submitted_user).id
    assert_not_empty cookies[:remember_me_token]
  end

  test 'login without remembering' do
    # login once w/ cookie to ensure no false positives;
    # logging in after, w/o remember, will also delete preexisting cookies
    log_in_as(@user)
    log_in_as(@user, remember_me: '0')
    assert_equal @user.id, assigns(:submitted_user).id
    assert_empty cookies[:remember_me_token]
  end
end
