class AddSlugIndexToLists < ActiveRecord::Migration[5.0]
  def change
    add_index :lists, :slug
  end
end
