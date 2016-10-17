class AddUserIdNameIndexToLists < ActiveRecord::Migration[5.0]
  def change
    add_index :lists, [:user_id, :name]
  end
end
