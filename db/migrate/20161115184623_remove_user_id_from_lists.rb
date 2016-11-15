class RemoveUserIdFromLists < ActiveRecord::Migration[5.0]
  def change
    remove_column :lists, :user_id, :integer
  end
end
