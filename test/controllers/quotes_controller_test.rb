# frozen_string_literal: true

require 'test_helper'

class QuotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quote = quotes(:one)
    add_users
    @user_dos.update_attribute(:admin, true)
    @user_dos.reload
  end

  test 'should get index' do
    get quotes_url
    assert_response :success
  end

  test 'should show quote' do
    get quote_url(@quote)
    assert_response :success
  end

  test 'should get new for admin' do
    log_in_as(@user_dos)
    get new_quote_url
    assert_response :success
  end

  test 'should create quote for admin' do
    log_in_as(@user_dos)
    assert_difference('Quote.count', 1) do
      author = authors(:one)
      post quotes_url, params: { quote: { passage: 'tis i, a new quote', author_id: author.id } }
    end
    newest_quote = Quote.order(created_at: :asc).last
    assert_redirected_to quote_url(newest_quote)
  end

  test 'should get edit for admin' do
    log_in_as(@user_dos)
    get edit_quote_url(@quote)
    assert_response :success
  end

  test 'should update quote for admin' do
    log_in_as(@user_dos)
    patch quote_url(@quote), params: { quote: { passage: 'voici! i am new again' } }
    assert_redirected_to quote_url(@quote)
  end

  test 'should destroy quote for admin' do
    log_in_as(@user_dos)
    assert_difference('Quote.count', -1) do
      delete quote_url(@quote)
    end
    assert_redirected_to quotes_url
  end

  test 'should reject new' do
    log_in_as(@user_uno)
    get new_quote_url
    assert_redirected_to root_url
  end

  test 'should reject create' do
    log_in_as(@user_uno)
    assert_no_difference('Quote.count') do
      author = authors(:one)
      post quotes_url, params: { quote: { passage: 'tis i, a new quote', author_id: author.id } }
    end
    assert_redirected_to root_url
  end

  test 'should reject edit' do
    log_in_as(@user_uno)
    get edit_quote_url(@quote)
    assert_redirected_to root_url
  end

  test 'should reject update' do
    log_in_as(@user_uno)
    patch quote_url(@quote), params: { quote: { passage: 'voici! i am new again' } }
    assert_redirected_to root_url
  end

  test 'should reject destroy' do
    log_in_as(@user_uno)
    assert_no_difference('Quote.count') do
      delete quote_url(@quote)
    end
    assert_redirected_to root_url
  end
end
