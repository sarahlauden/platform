# This file will create dummy data for the application, if not already present.
# This SHOULD NOT be used in production, which is why it's separate from the
# seeds file.

# Create people with contacts
person_count = Person.count
FactoryBot.create_list(:person_with_contacts, 5) unless person_count > 0
puts "Created #{Person.count - person_count} people"

program = Program.find_or_create_by name: 'SJSU'
role = Role.find_or_create_by name: 'Participant'

Person.all.each{|p| p.start_membership(program.id, role.id) if p.program_memberships.empty?}