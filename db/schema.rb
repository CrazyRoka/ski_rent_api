# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_23_100640) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "renter_id"
    t.date "start_date"
    t.date "end_date"
    t.integer "cost_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_bookings_on_item_id"
    t.index ["renter_id"], name: "index_bookings_on_renter_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "daily_price_cents"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_items_on_owner_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "author_id"
    t.text "description"
    t.string "reviewable_type"
    t.bigint "reviewable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_reviews_on_author_id"
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "encrypted_password"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookings", "items"
  add_foreign_key "bookings", "users", column: "renter_id"
  add_foreign_key "items", "users", column: "owner_id"
  add_foreign_key "reviews", "users", column: "author_id"
end
