FactoryBot.define do
  factory :person do
    transient do
      names do
        [
          ['Aaron', 'Anderson'], ['Anthony', 'Anderson'], ['Barry', 'Boswick'], ['Bill', 'Boswick'], 
          ['Bob', 'Boswick'], ['Cara', 'Clark'], ['Candice', 'Clark'], ['Carmen', 'Clark'], 
          ['Diana', 'Davis'], ['Daisy', 'Davis'], ['Deirdre', 'Davis'], ['Fred', 'Fox'], 
          ['Fran', 'Fox'], ['Gertie', 'Gray'], ['Greg', 'Gray'], ['Henry', 'Hill'], 
          ['Harrieta', 'Hill'], ['Harvey', 'Hill'], ['Jack', 'Jones'], ['Jenny', 'Jones'], 
          ['John', 'Jones'], ['Jeff', 'Jones']
        ]
      end
    end
    
    sequence(:first_name) { |i| names[i % names.size][0] }
    sequence(:last_name) { |i| names[i % names.size][1] }
    
    factory :person_with_contacts do
      transient do
        phones_count { 2 }
        emails_count { 3 }
        addresses_count { 3 }
      end
      
      after(:create) do |person, evaluator|
        phones = create_list(:phone, evaluator.phones_count, owner: person)
        create_list(:email, evaluator.emails_count, owner: person)
        create_list(:address, evaluator.addresses_count, owner: person)
      end
    end
  end
end
