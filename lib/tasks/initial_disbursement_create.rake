namespace :initial_disbursements_create do
  desc "initial disbursements calculate"
  task create: :environment do
    start_date = Order.minimum(:date)
    end_date = Order.maximum(:date) + 6.days # ensure that all of orders will be calculated, for production setup it could be change

    (start_date..end_date).each do |date|
      Merchant.find_each do |merchant|
        next if date < merchant.live_on
        next if merchant.disbursement_frequency == "WEEKLY" && merchant.live_on.wday != date.wday

        Disbursements::Create.new(merchant: merchant, date: date).call
      end
    end
  end
end
