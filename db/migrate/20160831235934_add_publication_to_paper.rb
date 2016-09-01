class AddPublicationToPaper < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :publication, :string
  end
end
