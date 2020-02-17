# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_10_130448) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "address_hash"
    t.decimal "balance", precision: 30, default: "0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "claim_events", force: :cascade do |t|
    t.string "address_hash"
    t.decimal "capacity", precision: 30
    t.integer "created_at_unixtimestamp"
    t.integer "status", limit: 2, default: 0
    t.bigint "ckb_transaction_id"
    t.inet "ip_addr"
    t.decimal "fee", precision: 20
    t.string "tx_hash"
    t.integer "tx_status", limit: 2, default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
end
