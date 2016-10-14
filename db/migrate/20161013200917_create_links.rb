class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :url
      t.integer :paper_id

      t.timestamps
    end
    add_index :links, :url
  end
end
