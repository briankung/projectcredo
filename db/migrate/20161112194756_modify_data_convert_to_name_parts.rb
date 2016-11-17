class ModifyDataConvertToNameParts < ActiveRecord::Migration[5.0]
  def up
    Author.find_each(batch_size: 50) do |author|
      name_parts = author.name.split(' ')
      author.last_name = name_parts.pop
      author.first_name = name_parts.join(' ')
      author.save
    end
  end

  def down
    Author.find_each(batch_size: 50) do |author|
      author.name = "#{author.first_name} #{author.last_name}"
      author.save
    end
  end
end
