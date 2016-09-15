class AddParentTypeToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :parent_type, :string
  end
end
