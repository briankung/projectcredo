class ChangeAuthorNameParts < ActiveRecord::Migration[5.0]
  def change
    rename_column :authors, :first_name, :given_name
    rename_column :authors, :last_name, :family_name
  end
end
