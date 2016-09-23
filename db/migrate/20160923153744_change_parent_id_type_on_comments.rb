class ChangeParentIdTypeOnComments < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :parent_id
    add_column :comments, :parent_id, :integer
  end
end
