# frozen_string_literal: true

class Author < ApplicationRecord
  self.implicit_order_column = 'slug'
  has_many :quotes, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true, on: :save

  before_save :build_slug

  def to_param
    slug
  end

  private

  def build_slug
    return unless name_changed? || new_record?

    sort_tokens = name.parameterize.split('-')
    # For sortability, prepend ~surname
    sort_tokens.unshift(sort_tokens.pop)
    self.slug = sort_tokens.join('-')
  end
end
