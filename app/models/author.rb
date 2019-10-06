# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :quotes, dependent: :destroy
  before_save :build_sortable_name

  def build_sortable_name
    return unless name_changed? || new_record?

    self.sortable_name = "#{name.split[-1].downcase} #{name.split[0].downcase}"
  end
end
