FactoryBot.define do
  factory :phone do
    sequence(:value) {|i| "402-291-#{sprintf('%04d', i)}"}
  end
end
