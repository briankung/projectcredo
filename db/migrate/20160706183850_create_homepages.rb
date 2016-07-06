class CreateHomepages < ActiveRecord::Migration[5.0]
  def change
    create_table :homepages, id: :uuid do |t|
      t.uuid :user_id, foreign_key: true

      t.timestamps
    end
  end
end
