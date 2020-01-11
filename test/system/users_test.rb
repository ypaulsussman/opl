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
    ActionMailer::Base.deliveries.clear
    visit root_url
    click_link 'Sign Up'

    fill_in 'Name', with: 'newuser mcuserton'
    fill_in 'Email', with: 'new_user@example.com'
    fill_in 'Password', with: 'foobar'
    fill_in 'Confirmation', with: 'foobar'
    assert_emails 1 do
      click_button 'Create User'
    end
    assert_text 'Excellent! Please check your email to activate your account.'

    new_user = User.find_by(email: 'new_user@example.com')
    log_in_as(new_user)
    assert_text 'Account not activated. Check your email for the activation link.'

    path_from_email_link =
      ActionMailer::Base.deliveries.first.text_part.body.to_s[%r{/account(.*)}]
    visit path_from_email_link
    assert_text 'Account activated -- welcome!'
  end

  test 'recovering a user password' do
    ActionMailer::Base.deliveries.clear
    visit root_url
    click_link 'Log In'
    click_link '(forgot password)'
    fill_in 'Email', with: 'foo@bar.com'
    assert_emails 1 do
      click_button 'Submit'
    end

    path_from_email_link =
      ActionMailer::Base.deliveries.first.text_part.body.to_s[%r{/password(.*)}]
    visit path_from_email_link
    fill_in 'Password', with: 'passwordeux'
    fill_in 'Confirmation', with: 'passwordeux'
    click_button 'Update Password'

    assert_text 'Password has been reset.'
  end

  test 'updating a User' do
    log_in_as(@non_admin)
    visit users_url
    click_link 'Settings'

    fill_in 'Personal URL path', with: @admin.slug
    click_on 'Update User'

    assert_text 'Slug has already been taken'

    fill_in 'Email', with: 'new_email@example.com'
    fill_in 'Name', with: 'myrad newname'
    fill_in 'Personal URL path', with: 'wow-cool-slug'
    click_on 'Update User'

    assert_text 'User was successfully updated'
    assert page.has_content?('new_email@example.com')
    assert page.has_content?('myrad newname')
    assert page.has_content?('wow-cool-slug')
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
