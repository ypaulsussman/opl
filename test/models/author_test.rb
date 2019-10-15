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

  test 'ensures name uniqueness' do
    duplicate_author = @author.dup
    @author.save
    assert_not duplicate_author.valid?
  end
end
