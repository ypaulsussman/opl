# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :quotes, dependent: :destroy
  scope :by_surname, lambda {
    all
      .map { |a| { name: a.name, sort_name: a.name.split[-1].downcase, id: a.id } }
      .sort_by { |a| a[:sort_name]}
      # .map { |a| { name: a, id: a[:id] } }
  }

  def stylized_name
    "yep, it's #{name}"
  end
end
