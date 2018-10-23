FactoryBot.define do
  factory :interest do
    sequence(:name) {|i| "Interest #{i}"}
  end
end
