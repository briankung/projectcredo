class AddParticipantsToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :participants, :integer, default: List.participants[:public], null: false
  end
end
