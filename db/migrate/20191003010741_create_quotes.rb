# frozen_string_literal: true

class CreateQuotes < ActiveRecord::Migration[6.0]
  def change
    create_table :quotes, id: :uuid do |t|
      t.string :passage
      t.references :author, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
