FactoryBot.define do
  factory :email do
    sequence(:value) { |i| "bob#{i}@example.com" }
  end
end
