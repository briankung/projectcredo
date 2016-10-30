class RemoveDataFromImportFromPapers < ActiveRecord::Migration[5.0]
  def change
    remove_column :papers, :data_from_import
  end
end
