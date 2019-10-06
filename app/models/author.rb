# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :quotes, dependent: :destroy
  scope :by_surname, lambda { all.sort_by(&:sortable_name) }

  def sortable_name
    name.split[-1].downcase
  end
end
