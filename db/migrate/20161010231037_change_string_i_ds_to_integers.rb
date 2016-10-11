class ChangeStringIDsToIntegers < ActiveRecord::Migration[5.0]
  def change
    change_column :comments, :user_id,  'integer USING user_id::integer'
    change_column :taggings, :tagger_id,  'integer USING tagger_id::integer'
    change_column :taggings, :taggable_id,  'integer USING taggable_id::integer'
    change_column :votes, :voter_id,  'integer USING voter_id::integer'
    change_column :votes, :votable_id,  'integer USING votable_id::integer'
  end
end
