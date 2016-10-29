class AddDataFromImportToPapers < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :data_from_import, :jsonb
  end
end
