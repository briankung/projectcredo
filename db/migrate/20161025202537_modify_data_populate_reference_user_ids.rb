class ModifyDataPopulateReferenceUserIds < ActiveRecord::Migration[5.0]
  def change
    Reference.find_each {|ref| ref.update_column(:user_id, ref.list.user.id)}
  end
end
