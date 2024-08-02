class CreateMonthlyFeesWorker
  include Sidekiq::Worker

  def perform
    date = Date.today.prev_month
    Merchant.find_each do |merchant|
      MonthlyFees::Create.new(
        merchant: merchant,
        year: date.year,
        month: date.month
      ).call
    end
  end
end
