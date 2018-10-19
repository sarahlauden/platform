# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

industry_names = YAML.load(File.read("#{Rails.root}/db/seeds/industries.yml"))

if Industry.count == 0
  Industry.create industry_names.map{|name| {name: name}}
end
