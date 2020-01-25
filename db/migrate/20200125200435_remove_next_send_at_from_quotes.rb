# frozen_string_literal: true

class RemoveNextSendAtFromQuotes < ActiveRecord::Migration[6.0]
  def change
    remove_column :quotes, :next_send_at, :datetime
  end
end
