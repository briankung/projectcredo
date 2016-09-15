class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments, id: :uuid do |t|
      t.text :content
      t.string :parent_id

      t.timestamps
    end
  end
end
