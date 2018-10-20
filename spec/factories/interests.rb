FactoryBot.define do
  factory :interest do
    sequence(:name) {|i| "Industry #{i}"}
  end
end
