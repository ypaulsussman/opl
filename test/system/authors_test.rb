# frozen_string_literal: true

require 'application_system_test_case'

class AuthorsTest < ApplicationSystemTestCase
  setup do
    create_initial_users
  end

  test 'visiting the index' do
    visit root_url
    click_link 'See All Authors'
    assert_selector 'h1', text: 'Authors'
  end

  test 'creating an Author' do
    log_in_as(@admin)
    visit root_url
    click_link 'See All Authors'
    click_on 'New Author'

    fill_in 'author_name', with: 'awesome wit'
    click_on 'Create Author'

    assert_text 'Author was successfully created'
    assert_selector 'h1', text: 'New Quote'
  end

  test 'updating an Author' do
    log_in_as(@admin)
    visit root_url
    click_link 'See All Authors'
    click_on 'Edit Author', match: :first

    fill_in 'author_name',  with: 'meep morp'
    click_on 'Update Author'

    assert_text 'Author was successfully updated'
    assert_selector 'h1', text: 'meep morp'
  end

  test 'destroying an Author' do
    log_in_as(@admin)
    visit root_url
    click_link 'See All Authors'
    click_on 'Edit Author', match: :first

    page.accept_confirm do
      click_on 'Remove Author', match: :first
    end

    assert_text 'Author was successfully destroyed'
    # TODO: once you've added differentiators via CSS selector,
    # navigate to root_url to assert all dependent quotes were deleted
  end
end
