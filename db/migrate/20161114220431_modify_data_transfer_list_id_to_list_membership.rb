class ModifyDataTransferListIdToListMembership < ActiveRecord::Migration[5.0]
  def up
    List.find_each(batch_size: 50) do |list|
      ListMembership.create user: list.user, list: list, role: 'owner'
    end
  end

  def down
    ListMembership.find_each(batch_size: 50) do |membership|
      list = membership.list
      list.update user: membership.user
      membership.destroy
    end
  end
end
