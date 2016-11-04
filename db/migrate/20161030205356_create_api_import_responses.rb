class CreateApiImportResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :api_import_responses do |t|
      t.text :xml
      t.jsonb :json
      t.text :source_uri, null: false
      t.references :paper, foreign_key: true

      t.timestamps
    end
  end
end
