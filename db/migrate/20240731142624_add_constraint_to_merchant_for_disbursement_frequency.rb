class AddConstraintToMerchantForDisbursementFrequency < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :merchants, "disbursement_frequency IN ('DAILY', 'WEEKLY')", name: "disbursement_frequency_check"
  end
end
