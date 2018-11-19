FactoryBot.define do
  factory :postal_code do
    sequence(:code) {|i| sprintf("%05d", 10000 + i)}
    city { 'Lincoln' }
    state { 'NE' }
    latitude { 45.0 }
    longitude { -105.0 }
  end
end
