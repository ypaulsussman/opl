# frozen_string_literal: true

class AddNextSendAtAndMostRecentlySentAtToQuotes < ActiveRecord::Migration[6.0]
  def change
    add_column :quotes, :next_send_at, :datetime
    add_column :quotes, :most_recently_sent_at, :datetime
  end
end
