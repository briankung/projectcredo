class AddUserToReferences < ActiveRecord::Migration[5.0]
  def change
    add_reference :references, :user, foreign_key: true
  end
end
