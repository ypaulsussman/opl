# frozen_string_literal: true

require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  class QuoteValidationTest < QuoteTest
    setup do
      @quote = quotes(:one)
    end

    test 'validates passage' do
      @quote.passage = ' '
      assert_not @quote.valid?
    end

    test 'ensures passage uniqueness' do
      duplicate_quote = @quote.dup
      @quote.save
      assert_not duplicate_quote.valid?
    end
  end

  class QuoteUpdateTest < QuoteTest
    setup do
      @old_author = authors(:one)
      @quote_one = Quote.create!(passage: 'foo', author: @old_author, next_send_at: Date.today)
      @new_author = authors(:two)
    end

    test 'on quote ownership-change, deletes orphan authors' do
      assert_equal @old_author.quotes_count, 1
      assert_difference('Author.count', -1) { @quote_one.update!(author: @new_author) }
    end

    test 'on quote ownership-change, ignores authors with remaining quotes' do
      Quote.create!(passage: 'bar', author: @old_author)
      assert_equal @old_author.quotes_count, 2
      assert_no_difference('Author.count') { @quote_one.update!(author: @new_author) }
    end
  end

  class QuoteDeletionTest < QuoteTest
    setup do
      @quote_author = authors(:one)
      @quote_one = Quote.create!(passage: 'foo', author: @quote_author, next_send_at: Date.today)
    end

    test 'on quote deletion, deletes orphan authors' do
      assert_equal @quote_author.quotes_count, 1
      assert_difference('Author.count', -1) { @quote_one.destroy }
    end

    test 'on quote deletion, ignores authors with remaining quotes' do
      Quote.create!(passage: 'bar', author: @quote_author)
      assert_equal @quote_author.quotes_count, 2
      assert_no_difference('Author.count') { @quote_one.destroy }
    end
  end
end
