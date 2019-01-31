FactoryBot.define do
  factory :role do
    sequence(:name) { |i| "Role #{i}" }
  end
end
