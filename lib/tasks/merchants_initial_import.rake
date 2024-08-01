require "csv"
namespace :merchants_initial do
  desc "merchants initial import"
  task import: :environment do
    CSV.foreach(Rails.root.join("tmp", "initial_data", "merchants.csv"), headers: true, col_sep: ";") do |row|
      hash_row = row.to_hash
      hash_row.merge!("external_id" => hash_row["id"])
        .delete("id")

      Merchant.create!(hash_row)
    end
  end
end
