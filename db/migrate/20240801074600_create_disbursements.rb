class CreateDisbursements < ActiveRecord::Migration[7.1]
  def change
    create_table :disbursements do |t|
      t.references :merchant, null: false, foreign_key: true
      t.string :reference, null: false
      t.decimal :total_amount, null: false, precision: 10, scale: 2
      t.decimal :total_fees, null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end
