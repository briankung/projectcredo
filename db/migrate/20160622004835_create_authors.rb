class CreateAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :authors, id: :uuid do |t|
      t.string :name
      t.string :title

      t.timestamps
    end
  end
end
