class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.date :date, null: false
      t.references :merchant, null: false, foreign_key: true
      t.decimal :fee_percentage, precision: 4, scale: 2, default: 0.0, null: false

      t.timestamps
    end
  end
end
