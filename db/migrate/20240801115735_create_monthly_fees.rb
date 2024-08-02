class CreateMonthlyFees < ActiveRecord::Migration[7.1]
  def change
    create_table :monthly_fees do |t|
      t.references :merchant, null: false, foreign_key: true
      t.integer :year, null: false
      t.integer :month, null: false
      t.decimal :fee_to_charge, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :charged_fee, precision: 10, scale: 2, default: 0.0, null: false

      t.timestamps
    end

    add_index :monthly_fees, [:merchant_id, :year, :month], unique: true
  end
end
