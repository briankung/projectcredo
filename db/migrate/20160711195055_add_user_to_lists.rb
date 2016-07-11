class AddUserToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :user_id, :uuid, default: "uuid_generate_v4()", null: false
  end
end
