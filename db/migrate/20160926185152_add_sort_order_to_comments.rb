class AddSortOrderToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :sort_order, :integer

    add_index :comments, :sort_order
  end
end
