FactoryBot.define do
  factory :access_token do
    sequence(:name) { |i| "Access Token #{i}"}
    sequence(:key)  { |i| sprintf("%016d", i) }
  end
end
