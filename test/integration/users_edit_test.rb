# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user.update!(password: 'foobar', password_confirmation: 'foobar')
    @user_dos = users(:two)
  end

  test 'edit unsuccessfully' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user),
          params: { user: {
            email: 'lol@regex_failure',
            name: '',
            slug: @user_dos.slug,
            password: 'foobar',
            password_confirmation: 'foobar'
          } }
    assert_template 'users/edit'
    assert_select '#error_explanation > h2', text: '3 errors prohibited this user from being saved:'
  end

  test 'edit successfully, with friendly forwarding' do
    get edit_user_path(@user)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    new_name = 'merpy newnham'
    new_email = 'lol@regex.success'
    new_slug = 'my-rad-path'
    patch user_path(@user),
          params: { user: {
            email: new_email,
            name: new_name,
            slug: new_slug,
            password: 'foobar',
            password_confirmation: 'foobar',
            receive_qotd: true
          } }
    follow_redirect!
    assert_template 'users/show'
    assert_select '#notice', text: 'User was successfully updated.'
    @user.reload
    assert_equal @user.name, new_name
    assert_equal @user.email, new_email
    assert_equal @user.slug, new_slug
    assert_equal @user.receive_qotd, true
  end
end
