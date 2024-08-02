FactoryBot.define do
  factory :monthly_fee do
    merchant
    year { 2024 }
    month { 8 }
    fee_to_charge { Faker::Number.decimal(l_digits: 2) }
    charged_fee { Faker::Number.decimal(l_digits: 3) }
  end
end
