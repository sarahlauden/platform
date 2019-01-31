FactoryBot.define do
  factory :program do
    sequence(:name) { |i| "Program #{i}" }
  end
end
