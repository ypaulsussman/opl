# frozen_string_literal: true

class RenameSortableNameToSlug < ActiveRecord::Migration[6.0]
  def change
    rename_column :authors, :sortable_name, :slug
    add_index :authors, :slug, unique: true
  end
end
