FactoryBot.define do
  factory :program_membership do
    association :person
    association :program
    association :role
  end
end
