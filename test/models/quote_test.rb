# frozen_string_literal: true

require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  setup do
    @quote = quotes(:one)
  end

  test 'validates name' do
    @quote.passage = ' '
    assert_not @quote.valid?
  end
end
