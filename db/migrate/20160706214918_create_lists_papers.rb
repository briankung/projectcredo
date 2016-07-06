class CreateListsPapers < ActiveRecord::Migration[5.0]
  def change
    create_table :lists_papers do |t|
      t.uuid :list_id
      t.uuid :paper_id

      t.timestamps
    end
  end
end
