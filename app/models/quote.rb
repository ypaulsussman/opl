# frozen_string_literal: true

class Quote < ApplicationRecord
  belongs_to :author, counter_cache: true
  validates :passage, presence: true
  before_save :set_orphan_author_for_deletion
  after_save :remove_orphan_author
  after_destroy :remove_silent_authors

  private

  # TODO: are the below _really_ better than just e.g. integrating the counter_culture gem?
  def set_orphan_author_for_deletion
    return unless persisted? && author_id_changed?

    prior_author = Author.find(author_id_was)
    @orphan_author = prior_author unless prior_author.quotes_count > 1
  end

  def remove_orphan_author
    @orphan_author.destroy unless @orphan_author.blank?
  end

  def remove_silent_authors
    author.destroy unless author.quotes_count.positive?
  end
end
