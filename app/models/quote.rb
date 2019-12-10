# frozen_string_literal: true

class Quote < ApplicationRecord
  belongs_to :author, counter_cache: true
  validates :passage, presence: true, uniqueness: true
  before_create :add_next_send_at
  before_save :set_orphaned_author
  after_save proc { @orphaned_author.destroy }, if: proc { @orphaned_author.present? }
  after_destroy proc { author.destroy }, if: proc { author.quotes_count.zero? }

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

  def set_orphaned_author
    return unless persisted? && author_id_changed?

    prior_author = Author.find(author_id_was)
    @orphaned_author = prior_author unless prior_author.quotes_count > 1
  end
end
