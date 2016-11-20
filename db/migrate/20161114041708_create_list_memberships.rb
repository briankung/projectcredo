class CreateListMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :list_memberships do |t|
      t.integer :user_id, null: false
      t.integer :list_id, null: false

      t.timestamps
    end

    add_index :list_memberships, [:user_id, :list_id], unique: true
  end
end
