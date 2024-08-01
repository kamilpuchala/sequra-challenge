namespace :initial_monthly_fee_create do
  desc "initial monthly fee create"
  task create: :environment do
    Merchant.find_each do |merchant|
      merchant_active_time(merchant).each do |active_year_month|
        MonthlyFees::Create.new(
          merchant: merchant,
          year: active_year_month[:year],
          month: active_year_month[:month]
        ).call
      end
    end
  end

  def merchant_active_time(merchant)
    years_months = []
    start_date = merchant.live_on
    end_date = Date.today.prev_month
    tmp_curr_date = start_date

    while tmp_curr_date <= end_date
      year_month = {
        year: tmp_curr_date.year,
        month: tmp_curr_date.month
      }

      years_months << year_month

      tmp_curr_date = tmp_curr_date.next_month
    end
    years_months
  end
end
