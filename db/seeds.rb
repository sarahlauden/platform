# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def yaml label
  YAML.load(File.read("#{Rails.root}/db/seeds/#{label}.yml"))
end

if Industry.count == 0
  Industry.create yaml(:industries).map{|name| {name: name}}
end

if Interest.count == 0
  Interest.create yaml(:interests).map{|name| {name: name}}
end

if Location.count == 0
  Location.create yaml(:locations).map{|attributes| {code: attributes['code'], name: attributes['name']}}
  
  # now add the relationships
  top_codes = yaml(:locations).select{|d| d['source'] == 'TOP'}.map{|d| d['code']}
  tops = Location.where(code: top_codes)

  yaml(:locations).each do |data|
    location = Location.find_by code: data['code']
    print '.'
    
    location.parents = case data['source']
    when 'TOP'
      tops - [location]
    when 'ST'
      tops
    else
      city, state_list = location.name.split(/,\s*/)
      
      if state_list
        Location.where(code: state_list.split('-')).all
      else
        []
      end
    end
  end
end

if Major.count == 0
  yaml(:majors).each do |category, major_names|
    category = Major.create name: category
    next if major_names.nil?

    major_names.each do |major_name|
      Major.create name: major_name, parent: category
    end
  end
end

puts