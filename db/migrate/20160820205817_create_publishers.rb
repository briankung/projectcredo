class CreatePublishers < ActiveRecord::Migration[5.0]
  def change
    create_table :publishers, id: :uuid  do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
