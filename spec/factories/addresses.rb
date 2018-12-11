FactoryBot.define do
  factory :address do
    sequence(:line1, 100) { |i| "#{i} Way Street"}

    city { "Lincoln" }
    state { "NE" }
    zip { "68521" }
  end
end
