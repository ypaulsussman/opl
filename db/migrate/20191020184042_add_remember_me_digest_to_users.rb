# frozen_string_literal: true

class AddRememberMeDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :remember_me_digest, :string
  end
end
