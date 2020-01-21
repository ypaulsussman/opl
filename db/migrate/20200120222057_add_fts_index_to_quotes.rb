# frozen_string_literal: true

class AddFtsIndexToQuotes < ActiveRecord::Migration[6.0]
  def change
    add_index(
      :quotes,
      "to_tsvector('english', passage)",
      using: :gin,
      name: 'index_quotes_on_passage'
    )
  end
end
