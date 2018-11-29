json.person do
  json.full_name @person.full_name
  json.first_name @person.first_name
  json.middle_name @person.middle_name
  json.last_name @person.last_name
  
  json.contacts ["coming soon"]
end