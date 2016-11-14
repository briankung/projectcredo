class CreateListMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :list_memberships do |t|
      t.references :user, foreign_key: true
      t.references :list, foreign_key: true

      t.timestamps
    end

    add_index :list_memberships, [:user_id, :list_id], unique: true
  end
end
