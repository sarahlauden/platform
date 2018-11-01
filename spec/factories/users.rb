FactoryBot.define do
  factory :user do
    sequence(:email) {|i| "test#{i}@example.com"}
    admin { false }
  end
end
