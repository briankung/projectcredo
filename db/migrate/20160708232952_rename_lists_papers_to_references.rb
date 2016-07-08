class RenameListsPapersToReferences < ActiveRecord::Migration[5.0]
  def change
    rename_table :lists_papers, :references
  end
end
