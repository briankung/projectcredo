class SplitAuthorNames < ActiveRecord::Migration[5.0]
  def change
    add_column :authors, :first_name, :text
    add_column :authors, :last_name, :text
  end
end
