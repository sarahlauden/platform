FactoryBot.define do
  factory :address do
    line1 { "123 Way Street" }
    city { "Lincoln" }
    state { "Nebraska" }
    zip { "68521" }
  end
end
