# frozen_string_literal: true

class AddTimesSentToQuotes < ActiveRecord::Migration[6.0]
  def change
    add_column :quotes, :times_sent, :integer, null: false, default: 0
  end
end
