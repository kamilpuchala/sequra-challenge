require "csv"
namespace :orders_initial do
  desc "orders initial import"
  task import: :environment do
    CSV.foreach(Rails.root.join("tmp", "initial_data", "orders.csv"), headers: true, col_sep: ";") do |row|
      merchant = Merchant.find_by!(reference: row["merchant_reference"])
      Order.create!(merchant: merchant,
        amount: row["amount"],
        date: row["created_at"])
    end
  end
end
