# frozen_string_literal: true

class Quote < ApplicationRecord
  belongs_to :author, counter_cache: true
  validates :passage, presence: true, uniqueness: true
  after_update :remove_orphaned_author
  after_destroy -> { author.destroy }, if: -> { author.quotes_count.zero? }

  private

  def remove_orphaned_author
    return unless previous_changes[:author_id].present?

    prior_author_id = previous_changes[:author_id][0]
    prior_author = Author.find(prior_author_id)
    prior_author.destroy unless prior_author.quotes_count.positive?
  end
end
