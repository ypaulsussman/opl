# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user.update!(password: 'foobar', password_confirmation: 'foobar')
  end

  test 'edit unsuccessfully' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch(
      user_path(@user),
      params: {
        user: {
          email: 'lol@regex_failure',
          name: '',
          password: 'foobar',
          password_confirmation: 'foobar'
        }
      }
    )
    assert_template 'users/edit'
    assert_select '#error_explanation > h2', text: '2 errors prohibited this user from being saved:'
  end

  test 'edit successfully, with friendly forwarding' do
    get edit_user_path(@user)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    new_name = 'merpy newnham'
    new_email = 'lol@regex.success'
    patch(
      user_path(@user),
      params: {
        user: {
          email: new_email,
          name: new_name,
          password: 'foobar',
          password_confirmation: 'foobar'
        }
      }
    )
    follow_redirect!
    assert_template 'users/show'
    assert_select '#notice', text: 'User was successfully updated.'
    @user.reload
    assert_equal @user.name, new_name
    assert_equal @user.email, new_email
  end
end
