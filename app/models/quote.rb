# frozen_string_literal: true

class Quote < ApplicationRecord
  belongs_to :author, counter_cache: true
  validates :passage, presence: true, uniqueness: true
  before_update :check_for_orphaned_author, if: -> { author_id_changed? }
  after_update -> { @orphaned_author.destroy }, if: -> { @orphaned_author.present? }
  after_destroy -> { author.destroy }, if: -> { author.quotes_count.zero? }

  private

  # TODO: when Rails 6.1 drops, replace this with a check against 
  # thequotes_count of author_previously_was, after_update, a la
  # https://blog.bigbinary.com/2019/12/03/rails-6-1-adds-_previously_was-attribute-methods.html
  def check_for_orphaned_author
    prior_author = Author.find(author_id_was)
    @orphaned_author = prior_author unless prior_author.quotes_count > 1
  end
end
