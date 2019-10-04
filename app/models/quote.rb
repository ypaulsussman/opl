# frozen_string_literal: true

class Quote < ApplicationRecord
  belongs_to :author, counter_cache: true
  validates :passage, presence: true
  after_destroy :remove_silent_authors

  def remove_silent_authors
    author.destroy! unless author.quotes_count.positive?
  end
end
