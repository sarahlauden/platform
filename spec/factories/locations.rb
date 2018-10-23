FactoryBot.define do
  factory :location do
    sequence(:code) {|i| "#{i}" }
    sequence(:name) {|i| "Location #{i}" }
  end
end
