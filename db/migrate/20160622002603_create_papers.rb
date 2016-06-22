class CreatePapers < ActiveRecord::Migration[5.0]
  def change
    create_table :papers, id: :uuid do |t|
      t.string :title
      t.date :published_at

      t.timestamps
    end
  end
end
