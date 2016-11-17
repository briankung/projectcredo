class AddFullNameToAuthors < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext
    add_column :authors, :full_name, :citext
    add_index :authors, :full_name, unique: true
  end
end
