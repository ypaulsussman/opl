# frozen_string_literal: true

class Author < ApplicationRecord
  self.implicit_order_column = 'sortable_name'
  has_many :quotes, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  before_save :build_sortable_name

  def build_sortable_name
    return unless name_changed? || new_record?

    sort_tokens = name.downcase.split
    self.sortable_name = "#{sort_tokens[-1]} #{sort_tokens[0]}"
  end
end
