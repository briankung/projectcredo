class AddEditableBooleanToLinksAndPapers < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :abstract_editable, :boolean, null: true, default: true
    add_column :papers, :paper_editable, :boolean, null: true, default: true
    add_column :links, :link_editable, :boolean, null: true, default: true
  end
end
