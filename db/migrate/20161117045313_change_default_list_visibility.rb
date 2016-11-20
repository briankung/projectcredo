class ChangeDefaultListVisibility < ActiveRecord::Migration[5.0]
  def up
    change_column :lists, :visibility, :integer, default: List.visibilities[:public]
  end

  def down
    change_column :lists, :visibility, :integer, default: 10
  end
end
