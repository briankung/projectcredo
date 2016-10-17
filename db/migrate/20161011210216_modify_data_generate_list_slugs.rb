class ModifyDataGenerateListSlugs < ActiveRecord::Migration[5.0]
  def up
    List.where(slug: nil).where.not(name: nil).find_each(&:set_slug!)
  end

  def down
  end
end
