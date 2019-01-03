json.person do
  json.full_name @person.full_name
  json.first_name @person.first_name
  json.middle_name @person.middle_name
  json.last_name @person.last_name
  
  json.contacts do
    json.phones @person.phones
    json.emails @person.emails
    json.addresses @person.addresses
  end
  
  json.program_memberships @person.program_memberships do |membership|
    json.program membership.program.name
    json.role membership.role.name
    json.start_date membership.start_date
    json.end_date membership.end_date
    json.current membership.current?
  end
end