# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u = User.create(email: 'user@example.com', password: 'password', username: 'testuser')

[
  "Allergies and immigrant families",
  "Crop co-cultivation methods",
  "Exercise and depression",
  "Do cellphones cause cancer?",
  "Protein consumption for muscular hypotrophy",
  "Efficacy of vitamin supplements",
  "The effect of probiotics on Irritable Bowel Syndrome",
  "Factors in second language acquisition",
  "Maintaining mobility in old age",
].each do |d|
  l = List.new(name: d, description: d, user: u)
  l.tag_list.add(d.split)
  l.save
end
