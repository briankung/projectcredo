class RequireReferenceListAndPaper < ActiveRecord::Migration[5.0]
  def change
    change_column :references, :list_id, :uuid, null: false
    change_column :references, :paper_id, :uuid, null: false
  end
end
