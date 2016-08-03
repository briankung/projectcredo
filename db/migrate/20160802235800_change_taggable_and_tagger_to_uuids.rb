class ChangeTaggableAndTaggerToUuids < ActiveRecord::Migration[5.0]
  def change
  	change_column :taggings, :taggable_id, :string
  	change_column :taggings, :tagger_id, :string
  end
end
