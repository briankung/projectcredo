class CreateJoinTableAuthorsPapers < ActiveRecord::Migration[5.0]
  def change
    create_table :authors_papers, id: false do |t|
      t.uuid :author_id
      t.uuid :paper_id

      t.index [:author_id, :paper_id]
      t.index [:paper_id, :author_id]
    end
  end
end
