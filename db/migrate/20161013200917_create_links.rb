class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :link
      t.string :link_type
      t.integer :paper_id

      t.timestamps
    end
    add_index :links, [:link, :link_type]
  end
end
