class RemoveParentTypeFromComments < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :parent_type
  end
end
