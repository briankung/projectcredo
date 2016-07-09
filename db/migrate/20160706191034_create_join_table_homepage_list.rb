class CreateJoinTableHomepageList < ActiveRecord::Migration[5.0]
  def change
    create_table :homepages_lists, id: false do |t|
      t.uuid :homepage_id
      t.uuid :list_id

      t.index [:homepage_id, :list_id]
      t.index [:list_id, :homepage_id]
    end
  end
end
