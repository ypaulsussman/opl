# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :quotes, dependent: :destroy
  before_save :build_sortable_name

  def build_sortable_name
    return unless name_changed? || new_record?

    sort_tokens = name.downcase.split
    self.sortable_name = "#{sort_tokens[-1]} #{sort_tokens[0]}"
  end
end
