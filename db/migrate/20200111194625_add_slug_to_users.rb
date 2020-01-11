# frozen_string_literal: true

class AddSlugToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :slug, :string
    User.all.each do |u|
      u.slug = "#{u.name.parameterize}-#{SecureRandom.uuid}"
      u.save!
    end
    change_column_null(:users, :slug, false)
    add_index :users, :slug, unique: true
  end
end
