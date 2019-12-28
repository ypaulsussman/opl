# frozen_string_literal: true

require 'test_helper'

class AuthorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @author = authors(:one)
    add_users
    @user_dos.update_attribute(:admin, true)
    @user_dos.reload
  end

  test 'should get index' do
    get authors_url
    assert_response :success
  end

  test 'should show author' do
    get author_url(@author)
    assert_response :success
  end

  test 'should get new for admin' do
    log_in_as(@user_dos)
    get new_author_url
    assert_response :success
  end

  test 'should create author for admin' do
    log_in_as(@user_dos)
    assert_difference('Author.count', 1) do
      post authors_url, params: { author: { name: 'filward millenary' } }
    end
    newest_author = Author.order(created_at: :asc).last
    assert_redirected_to new_quote_path(author_id: newest_author.id)
  end

  test 'should get edit for admin' do
    log_in_as(@user_dos)
    get edit_author_url(@author)
    assert_response :success
  end

  test 'should update author for admin' do
    log_in_as(@user_dos)
    patch author_url(@author), params: { author: { name: 'milward fillenary' } }
    assert_redirected_to author_url(@author)
  end

  test 'should destroy author for admin' do
    log_in_as(@user_dos)
    assert_difference('Author.count', -1) do
      delete author_url(@author)
    end
    assert_redirected_to authors_url
  end

  test 'should reject new for non-admin' do
    log_in_as(@user_uno)
    get new_author_url
    assert_redirected_to root_url
  end

  test 'should reject create for non-admin' do
    log_in_as(@user_uno)
    assert_no_difference('Author.count') do
      post authors_url, params: { author: { name: 'filward millenary' } }
    end
    assert_redirected_to root_url
  end

  test 'should reject edit for non-admin' do
    log_in_as(@user_uno)
    get edit_author_url(@author)
    assert_redirected_to root_url
  end

  test 'should reject update for non-admin' do
    log_in_as(@user_uno)
    patch author_url(@author), params: { author: { name: 'milward fillenary' } }
    assert_redirected_to root_url
  end

  test 'should reject destroy for non-admin' do
    log_in_as(@user_uno)
    assert_no_difference('Author.count') do
      delete author_url(@author)
    end
    assert_redirected_to root_url
  end
end
