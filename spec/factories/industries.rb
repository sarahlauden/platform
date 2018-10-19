FactoryBot.define do
  factory :industry do
    sequence(:name) {|i| "Industry #{i}"}
  end
end
