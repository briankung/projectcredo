class AddImportSourceToPaper < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :import_source, :text
  end
end
