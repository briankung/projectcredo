class RemoveLinkFromPapers < ActiveRecord::Migration[5.0]
  def change
    remove_column :papers, :link
  end
end
