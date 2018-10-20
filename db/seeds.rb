# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Industry.count == 0
  Industry.create YAML.load(File.read("#{Rails.root}/db/seeds/industries.yml")).map{|name| {name: name}}
end

if Interest.count == 0
  Interest.create YAML.load(File.read("#{Rails.root}/db/seeds/interests.yml")).map{|name| {name: name}}
end

if Major.count == 0
  data = YAML.load(File.read("#{Rails.root}/db/seeds/majors.yml"))
  
  data.each do |category, major_names|
    category = Major.create name: category
    next if major_names.nil?

    major_names.each do |major_name|
      Major.create name: major_name, parent: category
    end
  end
end