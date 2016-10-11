class AddIndexesToForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_index :authors_papers, [:author_id, :paper_id], unique: true
    add_index :comment_hierarchies, [:ancestor_id, :descendant_id], unique: true
    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :parent_id
    add_index :homepages, :user_id
    add_index :homepages_lists, [:homepage_id, :list_id], unique: true
    add_index :lists, :user_id
    remove_index :lists, name: "index_lists_on_cached_votes_up"
    add_index :lists, [:cached_votes_up, :created_at], order: { cached_votes_up: "DESC", created_at: "DESC NULLS LAST" }
    add_index :papers, [:link, :title], unique: true
    add_index :papers, :doi
    add_index :papers, :pubmed_id
    add_index :references, [:list_id, :paper_id], unique: true
    remove_index :references, name: "index_references_on_cached_votes_up"
    add_index :references, [:cached_votes_up, :created_at], order: { cached_votes_up: "DESC", created_at: "DESC NULLS LAST" }
  end
end
