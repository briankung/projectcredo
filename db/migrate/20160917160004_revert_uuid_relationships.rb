class RevertUuidRelationships < ActiveRecord::Migration[5.0]
  def change
    remove_column "authors_papers", 'author_id'
    remove_column "authors_papers", 'paper_id'

    remove_column "homepages", 'user_id'

    remove_column "homepages_lists", 'homepage_id'
    remove_column "homepages_lists", 'list_id'

    remove_column "lists", 'user_id'

    remove_column "references", 'list_id'
    remove_column "references", 'paper_id'

    remove_column "comment_hierarchies", 'ancestor_id'
    remove_column "comment_hierarchies", 'descendant_id'

    add_column "authors_papers", 'author_id', :integer, null: false
    add_column "authors_papers", 'paper_id', :integer, null: false

    add_column "homepages", 'user_id', :integer, null: false

    add_column "homepages_lists", 'homepage_id', :integer, null: false
    add_column "homepages_lists", 'list_id', :integer, null: false

    add_column "lists", 'user_id', :integer, null: false

    add_column "references", 'list_id', :integer, null: false
    add_column "references", 'paper_id', :integer, null: false

    add_column "comment_hierarchies", 'ancestor_id', :integer
    add_column "comment_hierarchies", 'descendant_id', :integer
  end
end
