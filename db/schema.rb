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

ActiveRecord::Schema[7.0].define(version: 2023_01_05_110905) do
  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tag"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "item_type"
    t.bigint "isbn"
    t.string "author"
    t.date "release_date"
    t.string "genre"
    t.string "language"
    t.integer "number_of_pages"
    t.string "publisher"
    t.integer "edition"
    t.string "director"
    t.string "format"
    t.integer "fsk"
    t.string "illustrator"
    t.integer "number_of_players"
    t.integer "playing_time"
    t.string "category"
    t.float "lat"
    t.float "lng"
    t.integer "max_borrowing_days", default: 1, null: false
    t.integer "max_reservation_days", default: 1, null: false
  end

  create_table "lendings", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "user_id", null: false
    t.datetime "started_at", null: false
    t.datetime "completed_at"
    t.datetime "due_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_lendings_on_item_id"
    t.index ["user_id"], name: "index_lendings_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "notification_type"
    t.string "message"
    t.datetime "sent", precision: nil
    t.boolean "display"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "group_id", null: false
    t.integer "permission_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_permissions_on_group_id"
    t.index ["item_id"], name: "index_permissions_on_item_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "user_id", null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_reservations_on_item_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name", default: "", null: false
    t.string "description", default: "", null: false
    t.string "provider", limit: 50, default: "", null: false
    t.string "uid", limit: 50, default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "lendings", "items"
  add_foreign_key "lendings", "users"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "permissions", "groups"
  add_foreign_key "permissions", "items"
  add_foreign_key "reservations", "items"
  add_foreign_key "reservations", "users"
end
