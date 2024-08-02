FactoryBot.define do
  factory :order do
    amount { Faker::Number.decimal(l_digits: 3) }
    date { Faker::Date.between(from: 2.years.ago, to: Date.today) }
    fee_percentage { 0.95 }
    merchant
  end
end
