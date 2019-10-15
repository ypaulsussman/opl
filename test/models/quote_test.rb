# frozen_string_literal: true

require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
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
