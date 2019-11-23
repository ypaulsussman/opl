# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    create_initial_users
  end

  test 'visiting the index' do
    log_in_as(@non_admin)
    visit users_url
    assert_selector 'h1', text: 'Quotes'
    assert_equal current_path, root_path
    click_link 'Log Out'
    log_in_as(@admin)
    click_link 'All Users'
    assert_selector 'h1', text: 'Users'
    assert_equal current_path, users_path
  end

  test 'creating a User' do
    visit root_url
    click_link 'Sign Up'

    fill_in 'Name', with: 'newuser mcuserton'
    fill_in 'Email', with: 'new_user@example.com'
    fill_in 'Password', with: 'foobar'
    fill_in 'Confirmation', with: 'foobar'
    click_button 'Create User'

    assert_text 'Excellent! Please check your email to activate your account.'
    assert page.has_content?('this is a very, very real quote')
    assert page.has_content?('Johannes Notrealerton')
  end

  test 'updating a User' do
    log_in_as(@non_admin)
    visit users_url
    click_link 'Settings'

    fill_in 'Email', with: 'new_email@example.com'
    fill_in 'Name', with: 'myrad newname'
    click_on 'Update User'

    assert_text 'User was successfully updated'
    assert page.has_content?('new_email@example.com')
    assert page.has_content?('myrad newname')
  end

  test 'destroying a User' do
    log_in_as(@admin)
    visit users_url
    page.accept_confirm do
      click_link 'Destroy', match: :first
    end

    assert_text 'User was successfully destroyed'
  end
end
