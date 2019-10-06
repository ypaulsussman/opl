# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :quotes, dependent: :destroy
  scope :by_surname, lambda {
    all
      .map { |a| a.name.split }
      .sort_by { |a| (a[-1] || '').downcase }
      .map { |a| a.join(' ') }
      .join(', ')
  }
end
