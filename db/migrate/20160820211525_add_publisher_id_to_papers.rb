class AddPublisherIdToPapers < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :publication_id, :uuid
  end
end
