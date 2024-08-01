FactoryBot.define do
  factory :merchant do
    external_id { Faker::Alphanumeric.alpha(number: 10) }
    reference { Faker::Company.name.underscore }
    email { Faker::Internet.email }
    live_on { Faker::Date.between(from: 30.days.ago, to: Date.today) }
    disbursement_frequency { ["DAILY", "WEEKLY"].sample }
    minimum_monthly_fee { Faker::Number.decimal(l_digits: 2) }
  end
end
