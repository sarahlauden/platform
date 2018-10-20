FactoryBot.define do
  factory :major do
    sequence(:name) {|i| "Major #{i}" }
    parent_id { nil }
  end
end
