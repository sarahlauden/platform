json.locations @locations do |location|
  json.id location.id
  json.name location.name
  json.parents location.parent_names
end
