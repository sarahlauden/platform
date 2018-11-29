FactoryBot.define do
  factory :contact_owner do
    association :owner, factory: :person
    association :contact, factory: :phone
  end
end
