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

ActiveRecord::Schema[7.1].define(version: 2024_07_31_142624) do
  create_table "merchants", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "reference", null: false
    t.string "email", null: false
    t.date "live_on", null: false
    t.string "disbursement_frequency", null: false
    t.decimal "minimum_monthly_fee", null: false
    t.integer "weekday", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_merchants_on_external_id", unique: true
    t.index ["reference"], name: "index_merchants_on_reference", unique: true
    t.check_constraint "disbursement_frequency IN ('DAILY', 'WEEKLY')", name: "disbursement_frequency_check"
  end

end
