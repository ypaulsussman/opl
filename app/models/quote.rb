# frozen_string_literal: true

class Quote < ApplicationRecord
  belongs_to :author, counter_cache: true
  validates :passage, presence: true, uniqueness: true
  before_create :add_next_send_at
  before_update :check_for_orphaned_author, if: -> { author_id_changed? }
  after_update -> { @orphaned_author.destroy }, if: -> { @orphaned_author.present? }
  after_destroy -> { author.destroy }, if: -> { author.quotes_count.zero? }

  private

  def add_next_send_at
    return if next_send_at.present?

    furthest_send_at_date =
      Quote
      .where.not(next_send_at: nil)
      .order(:next_send_at)
      .pluck(:next_send_at).last

    self.next_send_at = if furthest_send_at_date.present?
                          furthest_send_at_date + 1.day
                        else
                          Date.tomorrow
                        end
  end

  def check_for_orphaned_author
    prior_author = Author.find(author_id_was)
    @orphaned_author = prior_author unless prior_author.quotes_count > 1
  end
end
