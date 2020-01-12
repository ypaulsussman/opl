# frozen_string_literal: true

class AddSlugToQuotes < ActiveRecord::Migration[6.0]
  def change
    add_column :quotes, :slug, :string
    Quote.all.each do |q|
      opening_words = q.passage[/(^.{0,30}\S*\s)/][0..-2]
      q.slug = opening_words.parameterize
      q.save!
    end
    change_column_null(:quotes, :slug, false)
    add_index :quotes, :slug, unique: true
  end
end
