class CreatePublications < ActiveRecord::Migration[5.0]
  def change
    create_table :publications, id: :uuid  do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
