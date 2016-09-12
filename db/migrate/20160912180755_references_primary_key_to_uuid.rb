class ReferencesPrimaryKeyToUuid < ActiveRecord::Migration[5.0]
  def change
    add_column :references, :uuid, :uuid, default: "uuid_generate_v4()", null: false

    change_table :references do |t|
      t.remove :id
      t.rename :uuid, :id
    end
    execute "ALTER TABLE \"references\" ADD PRIMARY KEY (id);"
  end
end
