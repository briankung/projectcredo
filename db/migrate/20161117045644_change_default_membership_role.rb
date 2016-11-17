class ChangeDefaultMembershipRole < ActiveRecord::Migration[5.0]
  def up
    change_column :list_memberships, :role, :integer, default: ListMembership.roles[:owner]
  end

  def down
    change_column :list_memberships, :role, :integer, default: 10
  end
end
