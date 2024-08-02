# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_01_131211) do
  create_table "disbursements", force: :cascade do |t|
    t.integer "merchant_id", null: false
    t.string "reference", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.decimal "total_fees", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "reference_date"
    t.index ["merchant_id"], name: "index_disbursements_on_merchant_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "reference", null: false
    t.string "email", null: false
    t.date "live_on", null: false
    t.string "disbursement_frequency", null: false
    t.decimal "minimum_monthly_fee", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_merchants_on_external_id", unique: true
    t.index ["reference"], name: "index_merchants_on_reference", unique: true
    t.check_constraint "disbursement_frequency IN ('DAILY', 'WEEKLY')", name: "disbursement_frequency_check"
  end

  create_table "monthly_fees", force: :cascade do |t|
    t.integer "merchant_id", null: false
    t.integer "year", null: false
    t.integer "month", null: false
    t.decimal "fee_to_charge", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "charged_fee", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id", "year", "month"], name: "index_monthly_fees_on_merchant_id_and_year_and_month", unique: true
    t.index ["merchant_id"], name: "index_monthly_fees_on_merchant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.date "date", null: false
    t.integer "merchant_id", null: false
    t.decimal "fee_percentage", precision: 4, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "disbursement_id"
    t.index ["disbursement_id"], name: "index_orders_on_disbursement_id"
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  add_foreign_key "disbursements", "merchants"
  add_foreign_key "monthly_fees", "merchants"
  add_foreign_key "orders", "disbursements"
  add_foreign_key "orders", "merchants"
end
