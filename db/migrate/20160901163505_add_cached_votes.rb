class AddCachedVotes < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :cached_votes_up, :integer, default: 0
    add_column :references, :cached_votes_up, :integer, default: 0

    add_index :lists, :cached_votes_up
    add_index :references, :cached_votes_up
  end
end
