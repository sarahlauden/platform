FactoryBot.define do
  factory :email do
    sequence(:value) { |i| "test#{i}@example.com" }
  end
end
