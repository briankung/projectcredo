class AddSlugToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :slug, :string
  end
end
