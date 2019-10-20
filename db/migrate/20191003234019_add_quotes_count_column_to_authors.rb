# frozen_string_literal: true

class AddQuotesCountColumnToAuthors < ActiveRecord::Migration[6.0]
  def change
    add_column :authors, :quotes_count, :integer, null: false, default: 0
    execute <<~SQL
      UPDATE authors SET quotes_count = (
        SELECT count(*) FROM quotes
        WHERE quotes.author_id = authors.id
      );
    SQL
  end
end
