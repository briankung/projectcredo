class AddDescriptionToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :description, :string
  end
end
