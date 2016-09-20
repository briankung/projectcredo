class AddCachedVotesForComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :cached_votes_up, :integer, default: 0

    add_index :comments, :cached_votes_up
  end
end
