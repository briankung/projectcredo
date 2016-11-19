class ModifyDataConvertToNameParts < ActiveRecord::Migration[5.0]
  def up
    Author.find_each(batch_size: 50) do |author|
      name_parts = author.name.split(' ')

      author.update_column :last_name, name_parts.pop
      author.update_column :first_name, name_parts.join(' ')
    end
  end

  def down
    Author.find_each(batch_size: 50) do |author|
      author.update_column :name, "#{author.first_name} #{author.last_name}"
    end
  end
end
