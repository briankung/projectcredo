class AddAttributesToPapers < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :abstract, :text
    add_column :papers, :link, :string
    add_column :papers, :doi, :string
    add_column :papers, :pubmed_id, :string
  end
end
