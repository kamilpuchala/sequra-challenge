class AddDisbursementReferenceToOrder < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :disbursement, foreign_key: true
  end
end
