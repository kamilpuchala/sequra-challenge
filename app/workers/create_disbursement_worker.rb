class CreateDisbursementWorker
  include Sidekiq::Worker

  def perform
    date = Date.yesterday
    Merchant.find_each do |merchant|
      next if date < merchant.live_on
      next if merchant.disbursement_frequency == "WEEKLY" && merchant.live_on.wday != date.wday

      Disbursements::Create.new(merchant: merchant, date: date).call
    end
  end
end
