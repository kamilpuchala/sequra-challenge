class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants do |t|
      t.string :external_id, null: false, index: {unique: true}
      t.string :reference, null: false, index: {unique: true}
      t.string :email, null: false
      t.date :live_on, null: false
      t.string :disbursement_frequency, null: false
      t.decimal :minimum_monthly_fee, null: false, precision: 10, scale: 2
      t.integer :weekday, null: false

      t.timestamps
    end
  end
end
