class RemoveNameFromAuthors < ActiveRecord::Migration[5.0]
  def change
    remove_column :authors, :name, :text
  end
end
