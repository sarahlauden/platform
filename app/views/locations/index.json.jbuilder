json.locations @locations do |location|
  json.id location.id
  json.name location.name
  json.parents location.parent_names
end
  
json.pagination do
  json.per_page @locations.per_page
  json.current_page @locations.current_page
  json.total_pages @locations.total_pages
  
  if @locations.previous_page
    json.previous_page previous_page(@locations)
  end
  
  if @locations.next_page
    json.next_page next_page(@locations)
  end
end
