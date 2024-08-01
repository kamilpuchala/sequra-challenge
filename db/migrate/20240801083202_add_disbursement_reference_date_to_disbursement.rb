class AddDisbursementReferenceDateToDisbursement < ActiveRecord::Migration[7.1]
  def change
    add_column :disbursements, :reference_date, :date
  end
end
