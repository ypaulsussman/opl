class AddSortableNameColumnToAuthors < ActiveRecord::Migration[6.0]
  def change
    add_column :authors, :sortable_name, :string, null: false
  end
end
