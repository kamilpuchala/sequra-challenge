FactoryBot.define do
  factory :disbursement do
    merchant
    reference { "#{merchant.reference}_#{Date.today}" }
    total_amount { Faker::Number.decimal(l_digits: 4) }
    total_fees { Faker::Number.decimal(l_digits: 2) }
  end
end
