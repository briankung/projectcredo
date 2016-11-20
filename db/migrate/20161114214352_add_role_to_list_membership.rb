class AddRoleToListMembership < ActiveRecord::Migration[5.0]
  def change
    add_column :list_memberships, :role, :integer, null: false, default: 10
  end
end
