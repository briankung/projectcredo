class AddVisibilityToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :visibility, :integer, default: 10, null: false
  end
end
