json.location do
  json.id @location.id
  json.name @location.name
  
  json.children @location.children, :id, :name
  json.parents  @location.parents,  :id, :name
end