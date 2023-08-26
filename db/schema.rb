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

ActiveRecord::Schema[7.0].define(version: 2023_08_21_174431) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street1", null: false
    t.string "street2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "postal_code", null: false
    t.string "addressable_type"
    t.bigint "addressable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "awards", force: :cascade do |t|
    t.bigint "recipient_id"
    t.string "purpose"
    t.integer "amount_in_dollars"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_awards_on_recipient_id"
  end

  create_table "filers", force: :cascade do |t|
    t.string "ein", null: false
    t.string "business_name", null: false
    t.bigint "filing_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ein"], name: "index_filers_on_ein", unique: true
    t.index ["filing_id"], name: "index_filers_on_filing_id"
  end

  create_table "filings", force: :cascade do |t|
    t.datetime "return_timestamp", precision: nil, null: false
    t.datetime "tax_period_start", precision: nil, null: false
    t.datetime "tax_period_end", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipients", force: :cascade do |t|
    t.string "ein"
    t.bigint "filing_id"
    t.string "business_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filing_id"], name: "index_recipients_on_filing_id"
  end

  add_foreign_key "awards", "recipients"
  add_foreign_key "filers", "filings"
  add_foreign_key "recipients", "filings"
end
