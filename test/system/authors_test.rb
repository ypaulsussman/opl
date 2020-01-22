# frozen_string_literal: true

require 'application_system_test_case'

class AuthorsTest < ApplicationSystemTestCase
  setup do
    create_initial_users
  end

  test 'visiting the index' do
    visit root_url
    click_link 'Browse Authors'
    assert_selector 'h1', text: 'Browse Authors'
    # by quotes-count: notrealerton first; equallefake second
    assert_selector '.author-link:first-of-type', text: 'Johannes Notrealerton'
    assert_selector '.author-link:last-of-type', text: 'Michaela Equallefake'
    # click toggle
    click_button 'Order by name'
    # by sortable-name: equallefake first; notrealerton second
    assert_selector '.author-link:first-of-type', text: 'Michaela Equallefake'
    assert_selector '.author-link:last-of-type', text: 'Johannes Notrealerton'
  end

  test 'creating an Author' do
    log_in_as(@admin)
    visit root_url
    click_link 'Browse Authors'
    click_on 'New Author'

    fill_in 'author_name', with: 'awesome wit'
    click_on 'Create Author'

    assert_text 'Author was successfully created'
    assert_selector 'h1', text: 'New Quote'
  end

  test 'updating an Author' do
    log_in_as(@admin)
    visit root_url
    click_link 'Johannes Notrealerton', match: :first
    click_on 'Edit Author', match: :first

    fill_in 'author_name',  with: 'meep morp'
    click_on 'Update Author'

    assert_text 'Author was successfully updated'
    assert_selector 'h1', text: 'meep morp'
  end

  test 'destroying an Author' do
    log_in_as(@admin)
    visit root_url
    click_link 'Michaela Equallefake'
    click_on 'Edit Author', match: :first

    page.accept_confirm do
      click_on 'Remove Author', match: :first
    end

    assert_text 'Author was successfully destroyed'
    click_on 'Browse Quotes'
    assert_no_text 'this quotation is also exceptionally real'
  end
end
