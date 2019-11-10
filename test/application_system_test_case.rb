# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :firefox, screen_size: [1400, 1400]

  def create_initial_users
    @non_admin = users(:one)
    @admin = users(:two)
    [@non_admin, @admin].each do |u|
      u.update!(password: 'foobar', password_confirmation: 'foobar')
    end
    @admin.update!(admin: true)
  end

  def log_in_as(user, password: 'foobar')
    visit root_url
    click_link 'Log In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Log in'
  end
end
