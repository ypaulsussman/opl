# frozen_string_literal: true

require 'application_system_test_case'

class QuotesTest < ApplicationSystemTestCase
  setup do
    create_initial_users
  end

  test 'visiting the index' do
    visit root_url
    assert_selector 'h1', text: 'Quotes'
    assert page.has_content? 'this is a very, very real quote'
    assert page.has_content? 'this quotation is also exceptionally real'
    assert page.has_content? 'wow peep how authentic this quote is'
    fill_in 'search-field-big', with: 'real'
    click_on 'Search'
    assert page.has_content? 'this is a very, very real quote'
    assert page.has_content? 'this quotation is also exceptionally real'
    refute page.has_content? 'wow peep how authentic this quote is'
  end

  test 'creating a Quote' do
    log_in_as(@non_admin)
    visit root_url
    assert_no_link 'New Quote'
    click_link 'Log Out'
    log_in_as(@admin)
    visit root_url
    click_link 'New Quote'

    fill_in 'quote_passage', with: 'yo peep my new quote!'
    select 'Johannes Notrealerton', from: 'quote_author_id'
    click_on 'Create Quote'

    assert_text 'Quote was successfully created'
    assert_text 'yo peep my new quote!'
    assert_text 'Johannes Notrealerton'
  end

  test 'updating a Quote' do
    log_in_as(@non_admin)
    visit root_url
    assert_no_link 'Edit'
    click_link 'Log Out'
    log_in_as(@admin)
    visit root_url
    # TODO: below click relies on alphabetical sorting of quotes
    # to ensure testing of both passage and author are updated;
    # replace with selector-matching when you add styles/classes/ids
    click_on 'Edit', match: :first

    fill_in 'quote_passage', with: 'wow look at this fresh quote'
    select 'Michaela Equallefake', from: 'quote_author_id'
    click_on 'Update Quote'

    assert_text 'Quote was successfully updated'
    assert_text 'wow look at this fresh quote'
    assert_text 'Michaela Equallefake'
  end

  test 'destroying a Quote' do
    log_in_as(@admin)
    visit root_url
    click_on 'Edit', match: :first

    page.accept_confirm do
      click_link 'Remove Quote', match: :first
    end

    assert_text 'Quote was successfully destroyed'
  end
end
