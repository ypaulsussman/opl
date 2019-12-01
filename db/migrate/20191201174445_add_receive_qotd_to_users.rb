# frozen_string_literal: true

class AddReceiveQotdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :receive_qotd, :boolean, default: false
  end
end
