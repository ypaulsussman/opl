# frozen_string_literal: true

class Quote < ApplicationRecord
  belongs_to :author, counter_cache: true

  validates :passage, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true, on: :save

  before_save :build_slug
  after_update :remove_orphaned_author
  after_destroy -> { author.destroy }, if: -> { author.quotes_count.zero? }

  def to_param
    slug
  end

  private

  def build_slug
    return unless passage_changed? || new_record?

    opening_words = if passage[/(^.{0,30}\S*\s)/]
                      passage[/(^.{0,30}\S*\s)/][0..-2]
                    else
                      SecureRandom.uuid
                    end
    self.slug = opening_words.parameterize
  end

  def remove_orphaned_author
    return unless previous_changes[:author_id].present?

    prior_author_id = previous_changes[:author_id][0]
    prior_author = Author.find(prior_author_id)
    prior_author.destroy unless prior_author.quotes_count.positive?
  end
end
