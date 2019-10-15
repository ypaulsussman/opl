# frozen_string_literal: true

require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  setup do
    @author = authors(:one)
  end

  test 'validates name' do
    @author.name = ' '
    assert_not @author.valid?
  end
end
